using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace FRCDetective
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class GameEntryPage : ContentPage
    {
        public GameEntryPage()
        {
            InitializeComponent();
        }

        void ShowAuto(object sender, EventArgs e)
        {
            btnAuto.BackgroundColor = Xamarin.Forms.Color.LightSteelBlue;
            btnTeleop.BackgroundColor = Xamarin.Forms.Color.White;

            GridAuto.IsVisible = true;
            GridTeleop.IsVisible = false;
        }

        void ShowTeleop(object sender, EventArgs e)
        {
            btnTeleop.BackgroundColor = Xamarin.Forms.Color.LightSteelBlue;
            btnAuto.BackgroundColor = Xamarin.Forms.Color.White;

            GridTeleop.IsVisible = true;
            GridAuto.IsVisible = false;
        }

        void UpdateSteppers(object sender, EventArgs e)
        {
            double top = stpAuto_BallsTop.Value;
            double bottom = stpAuto_BallsBottom.Value;

            string strTop = top.ToString();
            string strBottom = bottom.ToString();

            lblAuto_BallsTop.Text = String.Concat(Enumerable.Repeat("0", 2 - strTop.Length)) + strTop;
            lblAuto_BallsBottom.Text = String.Concat(Enumerable.Repeat("0", 2 - strBottom.Length)) + strBottom;

        }

    }
}