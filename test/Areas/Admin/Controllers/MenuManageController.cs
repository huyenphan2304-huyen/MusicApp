using MusicApp.Models;
using System;
using System.Linq;
using System.Configuration;
using System.Web.Mvc;
using PagedList;

namespace MusicApp.Areas.Admin.Controllers
{
    public class MenuManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Menu
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var Menus = db.Menus.ToList();
            if (Menus == null || !Menus.Any())
            {
                ViewBag.Message = "No Menus found.";
                return View();
            }

            // Tạo một ViewBag chứa thông tin phân biệt Menu chính và Submenu
            ViewBag.MainMenus = Menus.Where(m => m.ParentId == null).ToList();
            ViewBag.SubMenus = Menus.Where(m => m.ParentId != null).ToList();

            int pageNumber = page ?? 1;
            var pagedMenus = Menus.ToPagedList(pageNumber, pageSize);
           

            return View(pagedMenus);
        }
       

        // GET: Admin/Menu/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Menu/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Menu menu)
        {
            if (ModelState.IsValid)
            {
                db.Menus.InsertOnSubmit(menu);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(menu);
        }

        // GET: Admin/Menu/Edit/5
        public ActionResult Edit(int id)
        {
            var menu = db.Menus.FirstOrDefault(m => m.Id == id);
            if (menu == null)
            {
                return HttpNotFound();
            }
            return View(menu);
        }

        // POST: Admin/Menu/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Menu menu)
        {
            if (ModelState.IsValid)
            {
                var existingMenu = db.Menus.FirstOrDefault(m => m.Id == menu.Id);
                if (existingMenu != null)
                {
                    existingMenu.Name = menu.Name;
                    existingMenu.Url = menu.Url;
                    existingMenu.ParentId = menu.ParentId;
                    existingMenu.CategoryId = menu.CategoryId;
                    existingMenu.Meta = menu.Meta;
                    existingMenu.Hide = menu.Hide;
                    existingMenu.Order = menu.Order;
                    existingMenu.DateBegin = menu.DateBegin;
                    db.SubmitChanges();
                }
                return RedirectToAction("Index");
            }
            return View(menu);
        }

        // GET: Admin/Menu/Delete/5
        public ActionResult Delete(int id)
        {
            var menu = db.Menus.FirstOrDefault(m => m.Id == id);
            if (menu == null)
            {
                return HttpNotFound();
            }
            return View(menu);
        }

        // POST: Admin/Menu/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var menu = db.Menus.FirstOrDefault(m => m.Id == id);
            if (menu != null)
            {
                db.Menus.DeleteOnSubmit(menu);
                db.SubmitChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
