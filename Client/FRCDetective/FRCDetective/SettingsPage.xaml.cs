using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

using Newtonsoft.Json;
using PCLStorage;

namespace FRCDetective
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SettingsPage : ContentPage
    {
        public SettingsPage()
        {
            InitializeComponent();
        }
        protected async override void OnAppearing()
        {
            try
            {
                IFolder rootFolder = FileSystem.Current.LocalStorage;
                IFolder folder = await rootFolder.CreateFolderAsync("Config", CreationCollisionOption.OpenIfExists);
                IFile file = await folder.CreateFileAsync("settings", CreationCollisionOption.OpenIfExists);

                Settings settings = JsonConvert.DeserializeObject<Settings>(await file.ReadAllTextAsync());
                IPEntry.Text = settings.IP;
                PortEntry.Text = settings.Port.ToString();
                UIDEntry.Text = settings.UID.ToString();
            }
            catch { }
        }
        protected async override void OnDisappearing()
        {
            try
            {
                IFolder rootFolder = FileSystem.Current.LocalStorage;
                IFolder folder = await rootFolder.CreateFolderAsync("Config", CreationCollisionOption.OpenIfExists);
                IFile file = await folder.CreateFileAsync("settings", CreationCollisionOption.OpenIfExists);

                Settings settings = new Settings();

                settings.IP = IPEntry.Text;
                settings.Port = Convert.ToInt32(PortEntry.Text);
                settings.UID = Convert.ToInt64(UIDEntry.Text);

                string json = JsonConvert.SerializeObject(settings);
                await file.WriteAllTextAsync(json);
            }
            catch (Exception e) {
                DisplayAlert("Error", e.Message, ":(");
            }
        }

    }
}