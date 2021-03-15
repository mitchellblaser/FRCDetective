using System;
using System.Collections.Generic;

using Xamarin.Forms;

using Microcharts;
using SkiaSharp;

namespace FRCDetective
{
    public partial class AnalysisPage : ContentPage
    {
        public AnalysisPage()
        {
            InitializeComponent();


            var TeamStatEntries = new[]
            {
                new ChartEntry(68)
                {
                    Label = "Your Team",
                    ValueLabel = "112",
                    Color = SKColor.Parse("#2cadba")
                },
                new ChartEntry(212)
                {
                    Label = "Others",
                    ValueLabel = "648",
                    Color = SKColor.Parse("#3b3b3b")
                }
            };
            var TeamScoreEntries1 = new[]
            {
                new ChartEntry(20){ Color = SKColor.Parse("#8fbcb0") },
                new ChartEntry(38){ Color = SKColor.Parse("#8fbcb0") },
                new ChartEntry(27){ Color = SKColor.Parse("#8fbcb0") },
                new ChartEntry(34){ Color = SKColor.Parse("#8fbcb0") },
                new ChartEntry(20){ Color = SKColor.Parse("#8fbcb0") }
            };
            var TeamScoreEntries2 = new[]
            {
                new ChartEntry(4){ Color = SKColor.Parse("#dca786") },
                new ChartEntry(7){ Color = SKColor.Parse("#dca786") },
                new ChartEntry(6){ Color = SKColor.Parse("#dca786") },
                new ChartEntry(8){ Color = SKColor.Parse("#dca786") },
                new ChartEntry(10){ Color = SKColor.Parse("#dca786") }
            };

            var lineChart = new LineChart()
            {
                Entries = TeamScoreEntries1,
                BackgroundColor = SKColor.Empty,
                LineSize = 12,
                PointMode = PointMode.None,
                LineAreaAlpha = 32
            };
            var lineChartS2 = new LineChart()
            {
                Entries = TeamScoreEntries2,
                BackgroundColor = SKColor.Empty,
                LineSize = 12,
                PointMode = PointMode.None,
                LineAreaAlpha = 32
            };


            var donutChart = new DonutChart() { Entries = TeamStatEntries, LabelMode = LabelMode.None, BackgroundColor = SKColor.Parse("fff5f5f5") };
            TestChart.Chart = donutChart;
            LineChart.Chart = lineChart;
            LineChartS2.Chart = lineChartS2;

            
        }
    }
}
