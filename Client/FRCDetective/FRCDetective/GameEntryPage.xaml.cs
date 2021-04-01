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
        public GameEntryPage(RoundData round = null)
        {
            InitializeComponent();
            if (round != null)
            {
                // Init Data
                TeamEntry.Text = round.Team.ToString();
                RoundEntry.Text = round.Round.ToString();
                if (round.Alliance == 1) { chkRed.IsChecked = true; chkBlue.IsChecked = false; } else { chkRed.IsChecked = false; chkBlue.IsChecked = true;  }

                // Auto Data
                chkAuto_InitLine.IsChecked = round.InitLine;
                stpAuto_BallsTop.Value = round.AutoHighGoal;
                stpAuto_BallsBottom.Value = round.AutoLowGoal;

                // Teleop Data
                stp_BallsTop.Value = round.TeleopHighGoal;
                stp_BallsBottom.Value = round.TeleopLowGoal;
                chkRotation.IsChecked = round.ColourwheelRotation;
                chkPosition.IsChecked = round.ColourwheelPosition;
                if (round.Climb == 0)
                {
                    chkPark.IsChecked = false;
                    chkClimb.IsChecked = false;
                }
                else if (round.Climb == 1)
                {
                    chkPark.IsChecked = true;
                    chkClimb.IsChecked = false;
                }
                else if (round.Climb == 2)
                {
                    chkPark.IsChecked = false;
                    chkClimb.IsChecked = true;
                }
                chkLevel.IsChecked = round.Level;

                // Fouls
                stp_Foul.Value = round.Foul;
                stp_TechFoul.Value = round.TechFoul;
            }
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
            double autoTop = stpAuto_BallsTop.Value;
            double autoBottom = stpAuto_BallsBottom.Value;
            double top = stp_BallsTop.Value;
            double bottom = stp_BallsBottom.Value;
            double foul = stp_Foul.Value;
            double techfoul = stp_TechFoul.Value;

            string strAutoTop = autoTop.ToString();
            string strAutoBottom = autoBottom.ToString();
            string strTop = top.ToString();
            string strBottom = bottom.ToString();
            string strFoul = foul.ToString();
            string strTechFoul = techfoul.ToString();

            lblAuto_BallsTop.Text = String.Concat(Enumerable.Repeat("0", 2 - strAutoTop.Length)) + strAutoTop;
            lblAuto_BallsBottom.Text = String.Concat(Enumerable.Repeat("0", 2 - strAutoBottom.Length)) + strAutoBottom;
            lbl_BallsTop.Text = String.Concat(Enumerable.Repeat("0", 2 - strTop.Length)) + strTop;
            lbl_BallsBottom.Text = String.Concat(Enumerable.Repeat("0", 2 - strBottom.Length)) + strBottom;
            lbl_Foul.Text = String.Concat(Enumerable.Repeat("0", 2 - strFoul.Length)) + strFoul;
            lbl_TechFoul.Text = String.Concat(Enumerable.Repeat("0", 2 - strTechFoul.Length)) + strTechFoul;
        }

        void RedChecked(object sender, EventArgs e)
        {
            if (chkRed.IsChecked)
            {
                chkBlue.IsChecked = false;
            }
            else
            {
                chkBlue.IsChecked = true;
            }
        }

        void BlueChecked(object sender, EventArgs e)
        {
            if (chkBlue.IsChecked)
            {
                chkRed.IsChecked = false;
            }
            else
            {
                chkRed.IsChecked = true;
            }
        }

        void QualifierChecked(object sender, EventArgs e)
        {
            if (chkQuals.IsChecked)
            {
                chkFinal.IsChecked = false;
            }
            else
            {
                chkFinal.IsChecked = true;
            }
        }

        void FinalChecked(object sender, EventArgs e)
        {
            if (chkFinal.IsChecked)
            {
                chkQuals.IsChecked = false;
            }
            else
            {
                chkQuals.IsChecked = true;
            }
        }

        void ParkChecked(object sender, EventArgs e)
        {
            if (chkPark.IsChecked)
            {
                chkClimb.IsChecked = false;
            }
        }

        void ClimbChecked(object sender, EventArgs e)
        {
            if (chkClimb.IsChecked)
            {
                chkPark.IsChecked = false;
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
                // Init Data
                RoundData round = new RoundData();
                round.Team = Convert.ToInt32(TeamEntry.Text);
                round.Round = Convert.ToInt32(RoundEntry.Text);
                round.Alliance = Convert.ToInt32(chkRed.IsChecked);
                round.Division = 0;
                round.Type = Convert.ToInt32(chkFinal.IsChecked);
                round.Timestamp = DateTime.Now;

                // Auto Data
                round.InitLine = chkAuto_InitLine.IsChecked;
                round.AutoHighGoal = (int)stpAuto_BallsTop.Value;
                round.AutoLowGoal = (int)stpAuto_BallsBottom.Value;

                // Teleop Data
                round.TeleopHighGoal = (int)stp_BallsTop.Value;
                round.TeleopLowGoal = (int)stp_BallsBottom.Value;
                round.ColourwheelRotation = chkRotation.IsChecked;
                round.ColourwheelPosition = chkPosition.IsChecked;
                if (chkPark.IsChecked)
                {
                    round.Climb = 1;
                }
                else if (chkClimb.IsChecked)
                {
                    round.Climb = 2;
                }
                else
                {
                    round.Climb = 0;
                }
                round.Level = chkLevel.IsChecked;

                // Fouls
                round.Foul = (int)stp_Foul.Value;
                round.TechFoul = (int)stp_TechFoul.Value;




                string DisplayName = "";
                //DisplayName += "Round ";
                //DisplayName += RoundEntry.Text;
                if (chkRed.IsChecked) { DisplayName += " Red Alliance "; } else { DisplayName += " Blue Alliance "; }
                DisplayName += "Team ";
                DisplayName += TeamEntry.Text;
                round.DisplayName = DisplayName;
                

                string ID = "";
                ID += round.Division.ToString();
                ID += "-";
                ID += round.Type;
                ID += "-";
                ID += round.Round.ToString("D3");
                ID += "-";
                ID += round.Team.ToString("D5");

                round.ID = ID;

                string FileName = ID + ".json";
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
        }



        void DisplayError(string message)
        {
            DisplayAlert("Error", message, "this is so sad :(");
        }
    }
}