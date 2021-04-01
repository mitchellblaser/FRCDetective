using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
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
    public partial class RoundViewPage : ContentPage
    {
        public ObservableCollection<RoundData> RoundList = new ObservableCollection<RoundData>();
        GameData Game;
        public RoundViewPage(GameData game)
        {
            InitializeComponent();
            lstRounds.ItemsSource = RoundList;
            Game = game;
            lblTitle.Text = Game.DisplayName;
        }
        protected override void OnAppearing()
        {
            Refresh();
        }
        async void Refresh()
        {
            RoundList.Clear();

            foreach (var item in Game.Red)
            {
                if (item != null)
                {
                    RoundList.Add(item);
                }
            }
            foreach (var item in Game.Blue)
            {
                if (item != null)
                {
                    RoundList.Add(item);
                }
            }
        }
        public async void OnDelete(object sender, EventArgs e)
        {
            var mi = ((MenuItem)sender);
            RoundData round = (RoundData)mi.CommandParameter;

            RoundList.Remove(round);
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
            IFile file = await folder.CreateFileAsync(round.Filename, CreationCollisionOption.ReplaceExisting);
            await file.DeleteAsync();
        }

        async void ItemSelected(object sender, EventArgs e)
        {
            RoundData round = (RoundData)lstRounds.SelectedItem;
            if (!round.Synced)
            {
                await Navigation.PushAsync(new NewGameEntryPage(round));
            }
            else
            {
                await DisplayAlert("Edit Error", "This entry has already been synced with the server. Please connect to the server to edit.", "OK");
            }
        }
    }
}