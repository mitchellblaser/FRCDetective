using System;
using System.Collections.Generic;

using Xamarin.Forms;
using Xamarin.Essentials;


namespace FRCDetective
{
    public partial class NewGameEntryPage : ContentPage
    {
        public NewGameEntryPage()
        {
            InitializeComponent();
            
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

    }
}
