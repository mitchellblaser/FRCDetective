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

        public static TcpClient client;
        private static TcpListener listener;
        private static string ipString;

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
            IPAddress[] localIp = Dns.GetHostAddresses(Dns.GetHostName());
            foreach (IPAddress address in localIp)
            {
                if (address.AddressFamily == AddressFamily.InterNetwork)
                {
                    ipString = address.ToString();
                    connectLabel.Text = ipString;
                }
            }
        }
    }
}
