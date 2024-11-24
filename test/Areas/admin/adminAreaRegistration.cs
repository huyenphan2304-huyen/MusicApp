using System.Web.Mvc;

namespace MusicApp.Areas.Admin
{
    public class AdminAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "Admin";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            
            context.MapRoute(
                "AbumManager",
                "Admin/{controller}/{action}/{id}",
                new { controller = "AlbumManage", action = "Index", id = UrlParameter.Optional }

            );
            context.MapRoute(
                "SongManage",
                "Admin/{controller}/{action}/{id}",
                new { controller = "SongManage", action = "Index", id = UrlParameter.Optional }

            );
            context.MapRoute(
               "PlaylistManager",
               "Admin/{controller}/{action}/{id}",
               new { controller = "PlaylistManage", action = "Index", id = UrlParameter.Optional }

           );
            context.MapRoute(
               "ArtistManager",
               "Admin/{controller}/{action}/{id}",
               new { controller = "ArtistManage", action = "Index", id = UrlParameter.Optional }

           );
            context.MapRoute(
               "MenuManager",
               "Admin/{controller}/{action}/{id}",
               new { controller = "MenuManageManage", action = "Index", id = UrlParameter.Optional }

           );

            context.MapRoute(
             "Admin_default",
             "Admin/{controller}/{action}/{id}",
             defaults :new { controller="Admin", action = "Index", id = UrlParameter.Optional }
         );


        }
    }
}