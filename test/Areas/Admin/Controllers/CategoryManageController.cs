using MusicApp.Models;
using System;
using System.Linq;
using System.Configuration;
using System.Web.Mvc;
using PagedList;

namespace MusicApp.Areas.Admin.Controllers
{
    public class CategoryManageController : Controller
    {
        private MusicDbDataContext db = new MusicDbDataContext(ConfigurationManager.ConnectionStrings["MusicDbDataContext"].ConnectionString);

        // GET: Admin/Category
        public ActionResult Index(int? page, int pageSize = 10)
        {
            var Categories = db.Categories.ToList();
            if (Categories == null || !Categories.Any())
            {
                ViewBag.Message = "No Categories found.";
                return View();
            }
            int pageNumber = page ?? 1;
            var pagedCategories = Categories.ToPagedList(pageNumber, pageSize);

            return View(pagedCategories);
        }
      
        // GET: Admin/Category/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/Category/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(Category category)
        {
            if (ModelState.IsValid)
            {
                db.Categories.InsertOnSubmit(category);
                db.SubmitChanges();
                return RedirectToAction("Index");
            }
            return View(category);
        }

        // GET: Admin/Category/Edit/5
        public ActionResult Edit(int id)
        {
            var category = db.Categories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return HttpNotFound();
            }
            return View(category);
        }

        // POST: Admin/Category/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(Category category)
        {
            if (ModelState.IsValid)
            {
                var existingCategory = db.Categories.FirstOrDefault(c => c.Id == category.Id);
                if (existingCategory != null)
                {
                    existingCategory.Name = category.Name;
                    db.SubmitChanges();
                }
                return RedirectToAction("Index");
            }
            return View(category);
        }

        // GET: Admin/Category/Delete/5
        public ActionResult Delete(int id)
        {
            var category = db.Categories.FirstOrDefault(c => c.Id == id);
            if (category == null)
            {
                return HttpNotFound();
            }
            return View(category);
        }

        // POST: Admin/Category/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            var category = db.Categories.FirstOrDefault(c => c.Id == id);
            if (category != null)
            {
                db.Categories.DeleteOnSubmit(category);
                db.SubmitChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
