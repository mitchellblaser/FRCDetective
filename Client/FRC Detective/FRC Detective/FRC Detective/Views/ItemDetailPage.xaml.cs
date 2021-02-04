using FRC_Detective.ViewModels;
using System.ComponentModel;
using Xamarin.Forms;

namespace FRC_Detective.Views
{
    public partial class ItemDetailPage : ContentPage
    {
        public ItemDetailPage()
        {
            InitializeComponent();
            BindingContext = new ItemDetailViewModel();
        }
    }
}