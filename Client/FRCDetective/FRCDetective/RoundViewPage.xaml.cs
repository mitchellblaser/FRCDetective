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
        public string red1 { get; set; }
        public string red2 { get; set; }
        public string red3 { get; set; }
        public string blue1 { get; set; }
        public string blue2 { get; set; }
        public string blue3 { get; set; }

        public RoundViewPage(GameData game)
        {
            InitializeComponent();
            
            Game = game;
            RoundSelect.Text = Game.DisplayName;

            red1 = game.Red[0] != null ? game.Red[0].Team.ToString() : "####";
            red2 = game.Red[1] != null ? game.Red[1].Team.ToString() : "####";
            red3 = game.Red[2] != null ? game.Red[2].Team.ToString() : "####";
            blue1 = game.Blue[0] != null ? game.Blue[0].Team.ToString() : "####";
            blue2 = game.Blue[1] != null ? game.Blue[1].Team.ToString() : "####";
            blue3 = game.Blue[2] != null ? game.Blue[2].Team.ToString() : "####";
            BindingContext = this;
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

        public async void OnEdit(object sender, EventArgs e)
        {
            RoundData[] teams = Game.Red.Concat(Game.Blue).ToArray();
            List<string> options = new List<string>();
            foreach (RoundData team in teams)
            {
                if (team != null)
                {
                    options.Add(team.Team.ToString());
                }
            }
            string result = await DisplayActionSheet("Team", "cancel", null, options.ToArray());


            RoundData round = null;
            foreach (RoundData team in teams)
            {
                if (team != null && team.Team.ToString() == result)
                {
                    round = team;
                }
            }

            if (!round.Synced)
            {
                await Navigation.PushAsync(new NewGameEntryPage(round));
            }
            else
            {
                await DisplayAlert("Edit Error", "This entry has already been synced with the server. Please connect to the server to edit.", "OK");
            }
        }

        async void ItemSelected(object sender, EventArgs e)
        {
            Navigation.PushAsync(new AnalysisPage());
        }
    }
}