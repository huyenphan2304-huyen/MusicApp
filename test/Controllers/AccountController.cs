using MusicApp.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace MusicApp.Controllers
{
    public class AccountController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Account
        public ActionResult Index(string formType = "login")
        {
            if (formType == "register")
            {
                return RedirectToAction("Register");
            }
            return RedirectToAction("Login");
        }

        // Hiển thị form đăng nhập
        public ActionResult Login()
        {
            var loginform = db.LoginForms.FirstOrDefault();
            return View("LoginForm", loginform);
        }

        // Hiển thị form đăng ký
        public ActionResult Register()
        {
            var registerform = db.RegisterForms.FirstOrDefault();
            return View("RegisterForm", registerform);
        }
    }
}
