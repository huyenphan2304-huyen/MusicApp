﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using MusicApp.Models;
using MusicApp.ViewModels;

namespace MusicApp.Controllers
{
    public class HomeController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";
            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }

        public ActionResult RecommendLatestAlbums()
        {
            // Retrieve albums that are featured in the slides and have Hide = true
            var recommendLatestAlbums = db.Slides
                .Where(slide => slide.Hide == true)  // Filter by Hide = true
                .Join(db.Albums, slide => slide.AlbumId, album => album.Id, (slide, album) => album)  // Join with Albums
                .OrderBy(album => album.Order)  // Order by the Order property (ascending)
                .ThenByDescending(album => album.ReleaseDate)  // In case of tie, order by ReleaseDate descending
                .ToList();

            return PartialView("RecommendLatestAlbums", recommendLatestAlbums);
        }



        public ActionResult LatestAlbums()
        {
            var latestAlbums = db.Albums.ToList();
            return PartialView("LatestAlbums", latestAlbums);
        }

        public ActionResult RecommendedAlbums()
        {
            var recommendedAlbums = db.Albums.ToList();
            return PartialView("RecommendedAlbums", recommendedAlbums);
        }

        public ActionResult FirstFeaturedArtist()
        {
            var featuredArtist = db.Artists.FirstOrDefault();
            return PartialView("FirstFeaturedArtist", featuredArtist);
        }

        public ActionResult ContactSection()
        {
            var contactInfo = db.Contacts.FirstOrDefault();
            return PartialView("ContactSection", contactInfo);
        }

        public ActionResult MiscellaneousArea()
        {
            // Lấy danh sách các mục từ bảng Miscellaneous
            var miscellaneousItems = db.Miscellaneous
                .Where(m => !m.Hide) // Chỉ lấy những mục không bị ẩn
                .OrderBy(m => m.OrderPosition) // Sắp xếp theo OrderPosition
                .ToList();

            // Chia thành các nhóm
            var weeksTop = miscellaneousItems.Where(m => m.Type == "Top").ToList();
            var newHits = miscellaneousItems.Where(m => m.Type == "NewHits").ToList();
            var popularArtists = miscellaneousItems.Where(m => m.Type == "PopularArtists").ToList();

            // Trả về PartialView với dữ liệu đã phân loại
            ViewBag.WeeksTop = weeksTop;
            ViewBag.NewHits = newHits;
            ViewBag.PopularArtists = popularArtists;

            // Lấy tiêu đề cho từng nhóm
            ViewBag.WeeksTopTitle = weeksTop.FirstOrDefault()?.Type ?? "WeeksTop";
            ViewBag.NewHitsTitle = newHits.FirstOrDefault()?.Type ?? "New Hits";
            ViewBag.PopularArtistsTitle = popularArtists.FirstOrDefault()?.Type ?? "Popular Artist";

            return PartialView("MiscellaneousArea", miscellaneousItems);
        }

    }
}
