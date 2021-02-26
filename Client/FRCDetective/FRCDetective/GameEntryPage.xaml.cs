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

        public bool IsNumeric(string input)
        {
            int test;
            return int.TryParse(input, out test);
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

        void RedChecked(object sender, EventArgs e)
        {
            if (chkRed.IsChecked)
            {
                chkBlue.IsChecked = false;
            }
        }

        void BlueChecked(object sender, EventArgs e)
        {
            if (chkBlue.IsChecked)
            {
                chkRed.IsChecked = false;
            }
        }

        async void Save(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(TeamEntry.Text))
            {
                await DisplayAlert("Data Error", "Team Number Cannot Be Empty", "OK");
                return;
            }
            else if (!IsNumeric(TeamEntry.Text))
            {
                await DisplayAlert("Data Error", "Team Number Must Be Numeric", "OK");
                return;
            }
            else if (string.IsNullOrEmpty(RoundEntry.Text))
            {
                await DisplayAlert("Data Error", "Round Number Cannot Be Empty", "OK");
                return;
            }
            else if (!IsNumeric(RoundEntry.Text))
            {
                await DisplayAlert("Data Error", "Round Number Must Be Numeric", "OK");
                return;
            }
            else
            {
                RoundData round = new RoundData();
                round.Team = Convert.ToInt32(TeamEntry.Text);
                round.Round = Convert.ToInt32(RoundEntry.Text);
                round.Alliance = Convert.ToInt32(chkRed.IsChecked);
                round.Timestamp = DateTime.Now;

                string DisplayName = "";
                DisplayName += "Round ";
                DisplayName += RoundEntry.Text;
                if (chkRed.IsChecked) { DisplayName += " Red Alliance "; } else { DisplayName += " Blue Alliance "; }
                DisplayName += "Team ";
                DisplayName += TeamEntry.Text;
                round.DisplayName = DisplayName;

                round.InitLine = chkAuto_InitLine.IsChecked;
                round.AutoHighGoal = (int)stpAuto_BallsTop.Value;
                round.AutoLowGoal = (int)stpAuto_BallsBottom.Value;

                string FileName = "";
                FileName += RoundEntry.Text;
                if (chkRed.IsChecked) { FileName += "R"; } else { FileName += "B"; }
                FileName += "_";
                FileName += TeamEntry.Text;
                FileName += ".json";
                round.Filename = FileName;

                string json = JsonConvert.SerializeObject(round);

                IFolder rootFolder = FileSystem.Current.LocalStorage;
                IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
                IFile file = await folder.CreateFileAsync(FileName, CreationCollisionOption.ReplaceExisting);
                await file.WriteAllTextAsync(json);

                await DisplayAlert("Message", "Done", "OK");
            }
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


        void DisplayError(string message)
        {
            DisplayAlert("Error", message, "this is so sad :(");
        }
    }
}