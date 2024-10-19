﻿using System;

namespace MusicApp.ViewModels
{
    public class EventDetailViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string ImageUrl { get; set; }
        public DateTime Date { get; set; }
    }
}