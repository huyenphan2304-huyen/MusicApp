using System.Web.Mvc;
using System.Web.Routing;

namespace MusicApp
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            // Định nghĩa route mặc định cho Home
            routes.MapRoute(
                name: "Home",
                url: "",
                defaults: new { controller = "Home", action = "Index" }
            );

            // Định nghĩa route cho Event
            routes.MapRoute(
                name: "Event",
                url: "Event/{action}/{id}",
                defaults: new { controller = "Event", action = "Index", id = UrlParameter.Optional }
            );

            // Định nghĩa route cho Account
            routes.MapRoute(
                name: "Account",
                url: "Account/{action}/{id}",
                defaults: new { controller = "Account", action = "Index", id = UrlParameter.Optional }
            );

            // Định nghĩa route mặc định cho tất cả các controller còn lại
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
