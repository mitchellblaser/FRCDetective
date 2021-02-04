using FRC_Detective.ViewModels;
using FRC_Detective.Views;
using System;
using System.Collections.Generic;
using Xamarin.Forms;

namespace FRC_Detective
{
    public partial class AppShell : Xamarin.Forms.Shell
    {
        public AppShell()
        {
            InitializeComponent();
            Routing.RegisterRoute(nameof(ItemDetailPage), typeof(ItemDetailPage));
            Routing.RegisterRoute(nameof(NewItemPage), typeof(NewItemPage));
        }

    }
}
