using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

using Xamarin.Forms;

using Newtonsoft.Json;
using PCLStorage;


namespace FRCDetective
{
    public partial class NewGameEntryPage : ContentPage
    {
        public NewGameEntryPage(RoundData round = null)
        {
            InitializeComponent();
            // TODO: ADD DIVISION LOADING/SAVING(SETTINGS)
            if (round != null)
            {
                // Init Data
                TeamEntry.Text = round.Team.ToString();
                RoundSelect.Text = "Editing Round Q" + round.Round.ToString();
                if (round.Alliance == 1)
                {
                    BtnToggleRedAlliance.BackgroundColor = Color.DarkSlateBlue;
                    BtnToggleRedAlliance.TextColor = Color.White;

                    BtnToggleBlueAlliance.BackgroundColor = Color.Transparent;
                    BtnToggleBlueAlliance.TextColor = Color.Black;
                }
                else
                {
                    BtnToggleBlueAlliance.BackgroundColor = Color.DarkSlateBlue;
                    BtnToggleBlueAlliance.TextColor = Color.White;

                    BtnToggleRedAlliance.BackgroundColor = Color.Transparent;
                    BtnToggleRedAlliance.TextColor = Color.Black;
                }

                // Auto Data
                ChkInitLine.IsChecked = round.InitLine;
                LabelAutoHighGoal.Text = round.AutoHighGoal.ToString();
                LabelAutoLowGoal.Text = round.AutoLowGoal.ToString();

                // Teleop Data
                LabelTeleHighGoal.Text = round.TeleopHighGoal.ToString();
                LabelTeleLowGoal.Text = round.TeleopLowGoal.ToString();
                if (round.ColourwheelRotation)
                {
                    BtnTeleColorWheelRotation.BackgroundColor = Color.DarkSlateBlue;
                    BtnTeleColorWheelRotation.TextColor = Color.White;
                }
                if (round.ColourwheelPosition)
                {
                    BtnTeleColorWheelPosition.BackgroundColor = Color.DarkSlateBlue;
                    BtnTeleColorWheelPosition.TextColor = Color.White;
                }
                if (round.Climb == 0)
                {
                    TelePark.BackgroundColor = Color.Transparent;
                    TelePark.TextColor = Color.Black;

                    TeleClimb.BackgroundColor = Color.Transparent;
                    TeleClimb.TextColor = Color.Black;
                }
                else if (round.Climb == 1)
                {
                    TelePark.BackgroundColor = Color.DarkSlateBlue;
                    TelePark.TextColor = Color.White;

                    TeleClimb.BackgroundColor = Color.Transparent;
                    TeleClimb.TextColor = Color.Black;
                }
                else if (round.Climb == 2)
                {
                    TelePark.BackgroundColor = Color.Transparent;
                    TelePark.TextColor = Color.Black;

                    TeleClimb.BackgroundColor = Color.DarkSlateBlue;
                    TeleClimb.TextColor = Color.White;
                }
                if (round.Level)
                {
                    TeleSwitchLevel.BackgroundColor = Color.DarkSlateBlue;
                    TeleSwitchLevel.TextColor = Color.White;
                }

                // Fouls
                LabelFouls.Text = round.Foul.ToString();
                LabelTechFouls.Text = round.TechFoul.ToString();
            }
            else
            {
                SetRoundNumber();
            }

        }

         async void SetRoundNumber()
        {
            bool valid = false;
            string result = await DisplayPromptAsync("Round Entry", "Current Round Number");
            if (result == null)
            {
                await Navigation.PopAsync();
                return;
            }

            if (IsNumeric(result, true))
            {
                valid = true;
            }
            while (!valid)
            {
                result = await DisplayPromptAsync("Round Entry", "Invalid Round Number");
                if (result == null)
                {
                    await Navigation.PopAsync();
                    return;
                }
                if (IsNumeric(result, true))
                {
                    valid = true;
                }
            }

            RoundSelect.Text = "Editing Round Q" + result;
        }

        /* Define Custom UI Functions */
        void ToggleButton(Button button)
        {
            if (button.BackgroundColor != Color.DarkSlateBlue)
            {
                button.BackgroundColor = Color.DarkSlateBlue;
                button.TextColor = Color.White;
            }
            else
            {
                button.BackgroundColor = Color.Transparent;
                button.TextColor = Color.Black;
            }
        }
        void ToggleButtons(Button btn1, Button btn2)
        {

            if (btn1.BackgroundColor == Color.DarkSlateBlue)
            {
                btn1.BackgroundColor = Color.Transparent;
                btn1.TextColor = Color.Black;
            }
            else if (btn1.BackgroundColor != Color.DarkSlateBlue)
            {
                btn1.BackgroundColor = Color.DarkSlateBlue;
                btn1.TextColor = Color.White;

                btn2.BackgroundColor = Color.Transparent;
                btn2.TextColor = Color.Black;
            }
            else
            {
                btn2.BackgroundColor = Color.DarkSlateBlue;
                btn2.TextColor = Color.White;

                btn1.BackgroundColor = Color.Transparent;
                btn1.TextColor = Color.Black;
            }
        }
        void StepperControl(Label label, Boolean direction, int step, Boolean allowNegative)
        {
            if (direction)
            {
                label.Text = Convert.ToString(Convert.ToInt32(label.Text) + step);
            }
            else
            {
                int set = Convert.ToInt32(label.Text) - step;
                if (set > -1) { label.Text = Convert.ToString(set); }
            }

        }
        /* End Custom UI Functions */

        /* Assign Functions to our UI Buttons */
        void ToggleBlueAlliance(object sender, EventArgs e) { ToggleButtons(BtnToggleBlueAlliance, BtnToggleRedAlliance); }
        void ToggleRedAlliance(object sender, EventArgs e) { ToggleButtons(BtnToggleRedAlliance, BtnToggleBlueAlliance); }
        void AutoHighGoalIncrement(object sender, EventArgs e) { StepperControl(LabelAutoHighGoal, true, 1, false); }
        void AutoHighGoalDecrement(object sender, EventArgs e) { StepperControl(LabelAutoHighGoal, false, 1, false); }
        void AutoLowGoalIncrement(object sender, EventArgs e) { StepperControl(LabelAutoLowGoal, true, 1, false); }
        void AutoLowGoalDecrement(object sender, EventArgs e) { StepperControl(LabelAutoLowGoal, false, 1, false); }
        void TeleHighGoalIncrement(object sender, EventArgs e) { StepperControl(LabelTeleHighGoal, true, 1, false); }
        void TeleHighGoalDecrement(object sender, EventArgs e) { StepperControl(LabelTeleHighGoal, false, 1, false); }
        void TeleLowGoalIncrement(object sender, EventArgs e) { StepperControl(LabelTeleLowGoal, true, 1, false); }
        void TeleLowGoalDecrement(object sender, EventArgs e) { StepperControl(LabelTeleLowGoal, false, 1, false); }
        void TeleColorWheelPos(object sender, EventArgs e) { ToggleButton(BtnTeleColorWheelPosition); }
        void TeleColorWheelRot(object sender, EventArgs e) { ToggleButton(BtnTeleColorWheelRotation); }
        void TeleClimbPark(object sender, EventArgs e) { ToggleButtons(TelePark, TeleClimb); }
        void TeleClimbClimb(object sender, EventArgs e) { ToggleButtons(TeleClimb, TelePark); }
        void TeleClimbSwitch(object sender, EventArgs e) { ToggleButton(TeleSwitchLevel); }
        void FoulsIncrement(object sender, EventArgs e) { StepperControl(LabelFouls, true, 1, false); }
        void FoulsDecrement(object sender, EventArgs e) { StepperControl(LabelFouls, false, 1, false); }
        void TechFoulsIncrement(object sender, EventArgs e) { StepperControl(LabelTechFouls, true, 1, false); }
        void TechFoulsDecrement(object sender, EventArgs e) { StepperControl(LabelTechFouls, false, 1, false); }

        /* Saving */
        public bool IsNumeric(string input, bool positive = false)
        {
            int test;

            if (int.TryParse(input, out test))
            {
                if (positive)
                {
                    if (test >= 0)
                    {
                        return true;
                    }
                    return false;
                }
                return true;
            }
            return false;
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
            /*else if (string.IsNullOrEmpty(RoundEntry.Text))
            {
                await DisplayAlert("Data Error", "Round Number Cannot Be Empty", "OK");
                return;
            }
            else if (!IsNumeric(RoundEntry.Text))
            {
                await DisplayAlert("Data Error", "Round Number Must Be Numeric", "OK");
                return;
            }*/
            else
            {
                // Init Data
                RoundData round = new RoundData();
                round.Team = Convert.ToInt32(TeamEntry.Text);
                round.Round = Convert.ToInt32(RoundSelect.Text.Substring(RoundSelect.Text.IndexOf('Q') + 1));
                round.Alliance = Convert.ToInt32(BtnToggleRedAlliance.BackgroundColor == Color.DarkSlateBlue);
                round.Division = 0;
                //round.Type = Convert.ToInt32(chkFinal.IsChecked);
                round.Type = 0;                 // Change when round entry is added
                round.Timestamp = DateTime.Now;

                // Auto Data
                round.InitLine = ChkInitLine.IsChecked;
                round.AutoHighGoal = Convert.ToInt32(LabelAutoHighGoal.Text);
                round.AutoLowGoal = Convert.ToInt32(LabelAutoLowGoal.Text);

                // Teleop Data
                round.TeleopHighGoal = Convert.ToInt32(LabelTeleHighGoal.Text);
                round.TeleopLowGoal = Convert.ToInt32(LabelTeleLowGoal.Text);
                round.ColourwheelRotation = (BtnTeleColorWheelRotation.BackgroundColor == Color.DarkSlateBlue);
                round.ColourwheelPosition = (BtnTeleColorWheelPosition.BackgroundColor == Color.DarkSlateBlue);
                if (TelePark.BackgroundColor == Color.DarkSlateBlue)
                {
                    round.Climb = 1;
                }
                else if (TeleClimb.BackgroundColor == Color.DarkSlateBlue)
                {
                    round.Climb = 2;
                }
                else
                {
                    round.Climb = 0;
                }
                round.Level = (TeleSwitchLevel.BackgroundColor == Color.DarkSlateBlue);

                // Fouls
                round.Foul = Convert.ToInt32(LabelFouls.Text);
                round.TechFoul = Convert.ToInt32(LabelTechFouls.Text);




                string DisplayName = "";
                DisplayName += "Round ";
                DisplayName += round.Round.ToString();
                if (round.Alliance == 1) { DisplayName += " Red Alliance "; } else { DisplayName += " Blue Alliance "; }
                DisplayName += "Team ";
                DisplayName += round.Team.ToString();
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
                await Navigation.PopAsync();
            }
        }
    }
}
