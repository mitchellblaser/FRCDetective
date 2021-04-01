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

            red1points.Text = game.Red[0].GetScore(true).ToString();
            red2points.Text = game.Red[1].GetScore(true).ToString();
            red3points.Text = game.Red[2].GetScore(true).ToString();

            blue1points.Text = game.Blue[0].GetScore(true).ToString();
            blue2points.Text = game.Blue[1].GetScore(true).ToString();
            blue3points.Text = game.Blue[2].GetScore(true).ToString();


        }
        protected override void OnAppearing()
        {
            Refresh();
        }
        async void Refresh()
        {
            lblRed1.Text = red1;
            lblRed2.Text = red2;
            lblRed3.Text = red3;
            lblBlue1.Text = blue1;
            lblBlue2.Text = blue2;
            lblBlue3.Text = blue3;

            lblRed1point.Text = red1;
            lblRed2point.Text = red2;
            lblRed3point.Text = red3;
            lblBlue1point.Text = blue1;
            lblBlue2point.Text = blue2;
            lblBlue3point.Text = blue3;


        }
        public async void OnDelete(object sender, EventArgs e)
        {
            RoundData[] teams = Game.Red.Concat(Game.Blue).ToArray();
            List<string> options = new List<string>();
            foreach (RoundData team in teams)
            {
                if (team != null && !team.Synced)
                {
                    options.Add(team.Team.ToString());
                }
            }
            string result = await DisplayActionSheet("Team", "cancel", null, options.ToArray());

            if (!await DisplayAlert("Delete", "Are you sure you want to delete team " + result + "?", "Yes", "No")) { return; }
            
            red1 = red1 == result ? "####" : red1;
            red2 = red2 == result ? "####" : red2;
            red3 = red3 == result ? "####" : red3;
            blue1 = blue1 == result ? "####" : blue1;
            blue2 = blue2 == result ? "####" : blue2;
            blue3 = blue3 == result ? "####" : blue3;
            Refresh();
            

            RoundData round = null;
            foreach (RoundData team in teams)
            {
                if (team != null && team.Team.ToString() == result)
                {
                    round = team;
                }
            }

            

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
                if (team != null && !team.Synced)
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