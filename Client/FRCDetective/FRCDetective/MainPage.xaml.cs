using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using System.Net.Sockets;
using System.Net;
using System.Threading;

namespace FRCDetective
{
    public partial class MainPage : ContentPage
    {
        bool _netStatus = false;
        bool _lastNetStatus = false;


        private static string ip = "192.168.1.68";
        private static string port = "5584";
        private static Connection _instance;
        private TcpClient client;
        private bool isLoaded;


        public MainPage()
        {
            InitializeComponent();
            NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
        }

        protected async override void OnAppearing()
        {
            if (!isLoaded)
            {
                await Task.Run(async () =>
                {
                    await networkInterface();
                });
                isLoaded = true;
            }
        }

        async Task networkInterface()
        {
            while (true)
            {
                _netStatus = IsConnected;
                if (!_netStatus)
                {
                    connect();
                }

                if (_netStatus == false && _lastNetStatus == true)
                {
                    Device.BeginInvokeOnMainThread(() =>
                    {
                        NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
                    });
                }
                else if (_netStatus == true && _lastNetStatus == false)
                {
                    Device.BeginInvokeOnMainThread(() =>
                    {
                        NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_black_18dp.png");
                    });
                    _netStatus = true;
                    //send();
                }
                _lastNetStatus = _netStatus;
                Thread.Sleep(1000);
            }
        }

        public bool IsConnected
        {
            get
            {
                try
                {
                    if (client != null && client.Client != null && client.Client.Connected)
                    {
                        /* pear to the documentation on Poll:
                         * When passing SelectMode.SelectRead as a parameter to the Poll method it will return 
                         * -either- true if Socket.Listen(Int32) has been called and a connection is pending;
                         * -or- true if data is available for reading; 
                         * -or- true if the connection has been closed, reset, or terminated; 
                         * otherwise, returns false
                         */

                        // Detect if client disconnected
                        if (client.Client.Poll(0, SelectMode.SelectRead))
                        {
                            byte[] buff = new byte[1];
                            if (client.Client.Receive(buff, SocketFlags.Peek) == 0)
                            {
                                // Client disconnected
                                return false;
                            }
                            else
                            {
                                return true;
                            }
                        }

                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }

        async void entryPage(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new GameEntryPage());
        }

        void connect()
        {
            try
            {
                client = new TcpClient();

                var result = client.BeginConnect(IPAddressEntry.Text, Convert.ToInt32(PortEntry.Text), null, null);

                var success = result.AsyncWaitHandle.WaitOne(TimeSpan.FromSeconds(1));

                if (!success)
                {
                    throw new Exception("Failed to connect.");
                }

                // we have connected
                client.EndConnect(result);
            }
            catch (Exception e)
            {
                //DisplayAlert("Error", x.Message, "OK");
            }
        }
        void send(object sender, EventArgs e)
        {
            send();
        }

        void send()
        {
            byte[] time = BitConverter.GetBytes((ulong)DateTimeOffset.Now.ToUnixTimeSeconds());
            byte[] team = BitConverter.GetBytes((Int32)5584);

            byte[] data = new byte[41];

            data[0] = 0x00; data[1] = 0x11; data[2] = 0x22; data[3] = 0x33; // UID
            for (int i = 4; i < 12; i++)    // Time
            {
                data[i] = time[i - 4];
            }
            data[12] = 0;   // Division
            data[13] = 0;   // Round Type
            data[14] = 1;   // Round Number
            for (int i = 15; i < 19; i++)    // Team
            {
                data[i] = team[i - 15];
            }
            data[19] = 0;   // Alliance
            /* Auto */
            data[20] = 1;   // Initiation Line
            data[21] = 6;   // Top Balls
            data[22] = 0;   // Bottom Balls
            /* Teleop */
            data[23] = 50;  // Top Balls
            data[24] = 0;   // Bottom Balls
            data[25] = 1;   // Rotation Control
            data[26] = 1;   // Position Control
            data[27] = 2;   // Climb
            data[28] = 1;   // Level
            data[29] = 40;  // Foul
            data[30] = 40;  // Tech Foul
            data[29] = 0xFF;// Start Hash
            for (int i = 32; i < 40; i++)   // Hash
            {
                data[i] = 0xFF;
            }
            data[40] = 0;   // End Byte

            try
            {
                NetworkStream stream = client.GetStream();
                stream.Write(data, 0, data.Length);
            }
            catch(Exception e)
            {
                DisplayError(e.Message);
            }
        }
        void receive(object sender, EventArgs e)
        {
            try
            {
                NetworkStream stream = client.GetStream();
                byte[] data = new byte[256];
                Int32 bytes = stream.Read(data, 0, data.Length);
                DisplayAlert("Message", System.Text.Encoding.ASCII.GetString(data, 0, bytes), "OK");
            }
            catch (Exception ex)
            {
                DisplayError(ex.Message);
            }
        }
        void DisplayError(string message)
        {
            DisplayAlert("Error", message, "this is so sad :(");
        }
    }
}
