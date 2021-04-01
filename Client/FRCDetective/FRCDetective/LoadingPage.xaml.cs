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
    public partial class LoadingPage : ContentPage
    {
        private bool isLoaded = false;
        Page toPush;
        public LoadingPage(Page page, string pageText)
        {
            InitializeComponent();
            LoadingText.Text = "Loading " + pageText;
            toPush = page;
        }

        protected async override void OnAppearing()
        {
            if (isLoaded)
            {
                await Navigation.PopAsync();
            }
            else
            {
                await Navigation.PushAsync(toPush);
                Navigation.RemovePage(Navigation.NavigationStack[Navigation.NavigationStack.Count - 2]);
            }
            isLoaded = true;
        }
    }
}