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
        ObservableCollection<RoundData> roundList = new ObservableCollection<RoundData>();
        public ObservableCollection<RoundData> RoundList { get { return roundList; } }

        public FileViewPage()
        {
            InitializeComponent();
            lstFiles.ItemsSource = roundList;

            Refresh();
        }

        async void Refresh()
        {
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            foreach (IFile file in await folder.GetFilesAsync())
            {
                //Console.WriteLine(file.Name);
                string json = await file.ReadAllTextAsync();

                RoundData round = JsonConvert.DeserializeObject<RoundData>(json);
                RoundList.Add(round);
            }
        }
        public void OnMore(object sender, EventArgs e)
        {
            var mi = ((MenuItem)sender);
            RoundData round = (RoundData)mi.CommandParameter;

            DisplayAlert("More Context Action", round.DisplayName + " more context action", "OK");
        }

        public async void OnDelete(object sender, EventArgs e)
        {
            var mi = ((MenuItem)sender);
            RoundData round = (RoundData)mi.CommandParameter;

            RoundList.Remove(round);
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);
            IFile file = await folder.CreateFileAsync(round.Filename, CreationCollisionOption.ReplaceExisting);
            await file.DeleteAsync();
        }
    }
}