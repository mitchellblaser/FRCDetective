using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace FRCDetective
{
    public class GameData
    {
        public GameData(int number)
        {
            Red = new RoundData[3];
            Blue = new RoundData[3];

            Round = number;
            DisplayName = "Round " + number.ToString();
            RedString = "If you're seeing this, something broke";
            BlueString = "If you're seeing this, something broke";
        }
        public int Round { get; set; }
        public string DisplayName { get; set; }
        public RoundData[] Red { get; set; }
        public RoundData[] Blue { get; set; }
        public void AddTeam(RoundData round)
        {
            if (round.Alliance == 1)
            {
                for (int i = 0; i < 3; i++)
                {
                    if (Red[i] == null)
                    {
                        Red[i] = round;
                        break;
                    }
                }
            }
            else
            {
                for (int i = 0; i < 3; i++)
                {
                    if (Blue[i] == null)
                    {
                        Blue[i] = round;
                        break;
                    }
                }
            }

            GenerateTeamString();
        }
        public string RedString { get; set; }
        public string BlueString { get; set; }

        public void GenerateTeamString()
        {
            RedString = "";
            for (int i = 0; i < 3; i++)
            {
                if (Red[i] != null)
                {
                    RedString += Red[i].Team.ToString() + ", ";
                }
            }
            BlueString = "";
            if (RedString.Length > 0)
            {
                BlueString += "     ";
            }
            for (int i = 0; i < 3; i++)
            {
                if (Blue[i] != null)
                {
                    BlueString += Blue[i].Team.ToString() + ", ";
                }
            }

            if (RedString.Length > 0)
            {
                RedString = RedString.Remove(RedString.Length - 2);
            }
            if (BlueString.Length > 0)
            {
                BlueString = BlueString.Remove(BlueString.Length - 2);
            }
        }
    }
}
