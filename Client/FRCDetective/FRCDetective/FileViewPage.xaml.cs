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
        public ObservableCollection<RoundData> RoundList = new ObservableCollection<RoundData>();


        public FileViewPage()
        {
            InitializeComponent();
            lstFiles.ItemsSource = RoundList;
        }

        protected override void OnAppearing()
        {
            Refresh();
        }

        async void Refresh()
        {
            IFolder rootFolder = FileSystem.Current.LocalStorage;
            IFolder folder = await rootFolder.CreateFolderAsync("RoundData", CreationCollisionOption.OpenIfExists);

            foreach (IFile file in await folder.GetFilesAsync())
            {
                string json = await file.ReadAllTextAsync();

                RoundData round = JsonConvert.DeserializeObject<RoundData>(json);
                RoundList.Add(round);
            }
            List<RoundData> sortedList =  RoundList.OrderBy(o => o.Round).ToList();

            RoundList.Clear();

            foreach (var item in sortedList)
                RoundList.Add(item);

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

        async void ItemSelected(object sender, EventArgs e)
        {
            RoundData round = (RoundData)lstFiles.SelectedItem;
            if (!round.Synced)
            {
                await Navigation.PushAsync(new NewGameEntryPage(round));
            }
            else
            {
                await Navigation.PushAsync(new NewGameEntryPage(round));   // TEMPORARY REMOVE AFTER TESTING

                //await DisplayAlert("Edit Error", "This entry has already been synced with the server. Please connect to the server to edit.", "OK");
            }
        }
    }
}