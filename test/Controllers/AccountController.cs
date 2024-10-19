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
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult LoginForm()
        {
            var loginform = db.LoginForms.FirstOrDefault();
            return PartialView("LoginForm",loginform);

        }
        public ActionResult RegisterForm()
        {
            var registerform = db.RegisterForms.FirstOrDefault();

            return PartialView("RegisterForm",registerform);

        }
    }
}