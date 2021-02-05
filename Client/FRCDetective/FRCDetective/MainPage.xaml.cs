using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace FRCDetective
{
    public partial class MainPage : ContentPage
    {
        bool _netStatus = false;

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
    }
}
