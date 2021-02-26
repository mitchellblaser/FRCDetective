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

        void Save(object sender, EventArgs e)
        {
            Task.Run(async () =>
            {
                await SaveData();
            });

            DisplayAlert("Message", "Done", "OK");
        }

        async void Load(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new FileViewPage());
            /*
            try
            {
                IFolder rootFolder = FileSystem.Current.LocalStorage;
                IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
                IFile file = await folder.GetFileAsync("1B_5584hhh" + ".json");
                string json = await file.ReadAllTextAsync();

                RoundData round = JsonConvert.DeserializeObject<RoundData>(json);
                chkAuto_InitLine.IsChecked = round.InitLine;
                stpAuto_BallsTop.Value = round.AutoHighGoal;
                stpAuto_BallsBottom.Value = round.AutoLowGoal;
            }
            catch (Exception ex)
            {
                if (ex.GetType().ToString() == "PCLStorage.Exceptions.FileNotFoundException")   // Change when you learn to do this properly
                {
                    DisplayError("File Not Found\nAre you sure you have a local copy of the round and team?");
                }
                else
                {
                    DisplayError(ex.Message);
                }
            }
            */
        }

        async void Index(object sender, EventArgs e)
        {
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            foreach(IFile file in await folder.GetFilesAsync())
            {
                Console.WriteLine(file.Name);
            }
        }

        async Task SaveData()
        {
            RoundData round = new RoundData();
            round.DisplayName = "mitch";

            round.InitLine = chkAuto_InitLine.IsChecked;
            round.AutoHighGoal = (int)stpAuto_BallsTop.Value;
            round.AutoLowGoal = (int)stpAuto_BallsBottom.Value;

            string json = JsonConvert.SerializeObject(round);

            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
            IFile file = await folder.CreateFileAsync("1B_5584" + ".json", CreationCollisionOption.ReplaceExisting);
            await file.WriteAllTextAsync(json);
        }

        void DisplayError(string message)
        {
            DisplayAlert("Error", message, "this is so sad :(");
        }
    }
}