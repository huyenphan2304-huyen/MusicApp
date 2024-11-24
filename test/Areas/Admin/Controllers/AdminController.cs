using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Areas.Admin.Controllers
{
    public class AdminController : Controller
    {
        // GET: Admin/Admin
        public ActionResult Index()
        {
            return View();
        }
        // Quản lý trang Home
        public ActionResult ManageHome()
        {
            // Logic quản lý trang Home
            return View("ManageHome");
        }

        // Quản lý Event
        public ActionResult ManageEvents()
        {
            // Logic quản lý các sự kiện
            return View();
        }

        // Quản lý Album
        public ActionResult ManageAlbums()
        {
            // Logic quản lý album
            return View();
        }

        // Quản lý Category
        public ActionResult ManageCategories()
        {
            // Logic quản lý các thể loại nhạc
            return View();
        }

        // Quản lý Login
        public ActionResult ManageLogin()
        {
            // Logic quản lý trang đăng nhập
            return View();
        }

        // Quản lý My Library
        public ActionResult ManageLibrary()
        {
            // Logic quản lý thư viện nhạc của người dùng
            return View();
        }

    }
}