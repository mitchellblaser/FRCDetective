using FRC_Detective.Services;
using FRC_Detective.Views;
using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace FRC_Detective
{
    public partial class App : Application
    {

        public App()
        {
            InitializeComponent();

            DependencyService.Register<MockDataStore>();
            MainPage = new AppShell();
        }

        protected override void OnStart()
        {
        }

        protected override void OnSleep()
        {
        }

        protected override void OnResume()
        {
        }
    }
}
