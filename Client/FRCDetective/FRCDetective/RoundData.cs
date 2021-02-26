using System;
using System.Collections.Generic;
using System.Text;

namespace FRCDetective
{
    public class RoundData
    {
        public string Filename { get; set; }
        public string DisplayName { get; set; }
        public DateTime Timestamp { get; set; }
        public int Team { get; set; }
        public int Round { get; set; }
        public int Alliance { get; set; }
        public bool InitLine { get; set; }
        public int AutoHighGoal { get; set; }
        public int AutoLowGoal { get; set; }
    }
}
