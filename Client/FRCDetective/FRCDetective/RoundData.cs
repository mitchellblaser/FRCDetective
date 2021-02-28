using System;
using System.Collections.Generic;
using System.Text;

namespace FRCDetective
{
    public class RoundData
    {
        public RoundData()
        {
            Synced = false;
        }
        public string ID { get; set; }
        public string Filename { get; set; }
        public string DisplayName { get; set; }
        public DateTime Timestamp { get; set; }
        public bool Synced { get; set; }
        public int Team { get; set; }
        public int Round { get; set; }
        public int Division { get; set; }
        public int Type { get; set; }
        public int Alliance { get; set; }
        public bool InitLine { get; set; }
        public int AutoHighGoal { get; set; }
        public int AutoLowGoal { get; set; }
        public int TeleopHighGoal { get; set; }
        public int TeleopLowGoal { get; set; }
        public bool ColourwheelRotation { get; set; }
        public bool ColourwheelPosition { get; set; }
        public int Climb { get; set; }
        public bool Level { get; set; }
        public int Foul { get; set; }
        public int TechFoul { get; set; }

    }
}
