using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;
using System.Net.Sockets;
using System.Net;

namespace FRCDetective
{
    public partial class MainPage : ContentPage
    {
        bool _netStatus = false;


        private string ip = "192.168.1.68";
        private string port = "5584";
        private static Connection _instance;
        private TcpClient client;


        public MainPage()
        {
            InitializeComponent();
            NetworkStatus.Source = ImageSource.FromFile("baseline_sensors_off_black_18dp.png");

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
            byte[] message = System.Text.Encoding.ASCII.GetBytes("Hello World\n");
            NetworkStream stream = client.GetStream();
            stream.Write(message, 0, message.Length);
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
