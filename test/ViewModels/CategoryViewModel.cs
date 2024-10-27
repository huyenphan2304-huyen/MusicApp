using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MusicApp.ViewModels
{
    public class CategoryViewModel
    {
        public Category Category { get; set; }
        public List<SongViewModel> Songs { get; set; }
    }
}