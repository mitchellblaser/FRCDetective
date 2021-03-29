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
    public class Employee
    {
        public string DisplayName { get; set; }
    }
    public partial class FileViewPage : ContentPage
    {
        public ObservableCollection<GameData> GameList = new ObservableCollection<GameData>();


        public FileViewPage()
        {
            InitializeComponent();
            lstFiles.ItemsSource = GameList;
        }

        protected override void OnAppearing()
        {
            Refresh();
        }

        async void Refresh()
        {/*
            TeamList.Clear();
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            foreach (IFile file in await folder.GetFilesAsync())
            {
                string json = await file.ReadAllTextAsync();

                RoundData round = JsonConvert.DeserializeObject<RoundData>(json);
                TeamList.Add(round);
            }
            List<RoundData> sortedList = TeamList.OrderBy(o => o.Round).ToList();

            TeamList.Clear();

            foreach (var item in sortedList)
                TeamList.Add(item);*/

            GameList.Clear();
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
            List<RoundData> roundList = new List<RoundData>();
            List<GameData> tempGameList = new List<GameData>();

            foreach (IFile file in await folder.GetFilesAsync())
            {
                string json = await file.ReadAllTextAsync();

                RoundData round = JsonConvert.DeserializeObject<RoundData>(json);
                roundList.Add(round);
            }
            List<RoundData> sortedList = roundList.OrderBy(o => o.Round).ToList();
            int currentRound = -1;
            foreach (RoundData item in sortedList)
            {
                if (item.Round > currentRound)
                {
                    currentRound = item.Round;
                    tempGameList.Add(new GameData(currentRound));
                }
                tempGameList[tempGameList.Count() - 1].AddTeam(item);
            }

            foreach (var item in tempGameList)
                GameList.Add(item);
        }

        async void ItemSelected(object sender, EventArgs e)
        {
            RoundData round = (RoundData)lstFiles.SelectedItem;
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