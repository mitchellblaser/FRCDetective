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
        ObservableCollection<RoundData> myList = new ObservableCollection<RoundData>();
        public ObservableCollection<RoundData> MyList { get { return myList; } }

        public FileViewPage()
        {
            InitializeComponent();
            lstFiles.ItemsSource = myList;

            RoundData round1 = new RoundData();
            round1.DisplayName = "mitch";

            round1.InitLine = true;
            round1.AutoHighGoal = 1;
            round1.AutoLowGoal = 2;

            RoundData round2 = new RoundData();
            round2.DisplayName = "not mitch";

            round2.InitLine = true;
            round2.AutoHighGoal = 1;
            round2.AutoLowGoal = 2;

            MyList.Add(round1);
            MyList.Add(round2);
        }

        async void Refresh()
        {
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            foreach (IFile file in await folder.GetFilesAsync())
            {
                //Console.WriteLine(file.Name);
                
            }
        }
    }
}