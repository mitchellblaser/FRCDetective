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
        {/*
            while (true)
            {
                
            }*/
        }

        void toggleNetwork(object sender, EventArgs e)
        {
            if (_netStatus == true)
            {
                NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
                _netStatus = false;
            }
            else
            {
                NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_black_18dp.png");
                _netStatus = true;
            }
        }

        async void entryPage(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new GameEntryPage());
        }

        void connect(object sender, EventArgs e)
        {
            client = new TcpClient();

            try
            {
                client.Connect(ip, Convert.ToInt32(port));
                if (client.Connected)
                {
                    Connection.Instance.client = client;
                    NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_black_18dp.png");
                    _netStatus = true;
                    DisplayAlert("Success", "Connected", "OK");
                }
                else
                {
                    NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");
                    _netStatus = false;
                    DisplayAlert("Error", "Connection Failed", "OK");
                }
            }
            catch (Exception x)
            {
                 DisplayAlert("Error", x.Message, "OK");
            }
        }

        void send(object sender, EventArgs e)
        {
            byte[] time = BitConverter.GetBytes((ulong)DateTimeOffset.Now.ToUnixTimeSeconds());
            byte[] team = BitConverter.GetBytes((Int32)5584);

            Console.WriteLine(time);

            byte[] data = new byte[39];

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
            data[29] = 0xFF;// Start Hash
            for (int i = 30; i < 38; i++)   // Hash
            {
                data[i] = 0xFF;
            }
            data[38] = 0;   // End Byte


            NetworkStream stream = client.GetStream();
            stream.Write(data, 0, data.Length);
        }
        void receive(object sender, EventArgs e)
        {
            NetworkStream stream = client.GetStream();
            byte[] data = new byte[256];
            Int32 bytes = stream.Read(data, 0, data.Length);
            DisplayAlert("Message", System.Text.Encoding.ASCII.GetString(data, 0, bytes), "OK");
        }
    }
}
