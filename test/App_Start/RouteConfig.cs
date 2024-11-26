using System.Text.RegularExpressions;
using System.Web.Mvc;
using System.Web.Mvc.Routing.Constraints;
using System.Web.Routing;

namespace MusicApp
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            // Song/{categoryName}
            routes.MapRoute(
                name: "SongsByCategory",
                url: "Song/{categoryName}",
                defaults: new { controller = "Song", action = "GetListSongByCategory", id = UrlParameter.Optional }
            );
            // Route AlbumDetail 
            routes.MapRoute(
                name: "AlbumDetail",
                url: "album/{meta}/{id}",
                defaults: new { controller = "Album", action = "AlbumDetail", id = UrlParameter.Optional },
                namespaces: new[] { "MusicApp.Controllers" }
            );

            // route EventDetail
            routes.MapRoute(
                name: "EventDetail",
                 url: "{type}/{meta}/{id}",
                defaults: new { controller = "Event", action = "EventDetail", id = UrlParameter.Optional },
                constraints: new { type = "event" },
                        namespaces: new[] { "MusicApp.Controllers" }

            );
            // PlaylistDetail
            routes.MapRoute(
                name: "PlaylistDetail",
                 url: "{type}/{id}",
                defaults: new { controller = "Playlist", action = "PlaylistDetail", id = UrlParameter.Optional },
                constraints: new { type = "playlist" },
                        namespaces: new[] { "MusicApp.Controllers" }

            );
            // SongDetail
            routes.MapRoute(
                name: "SongDetail",
                 url: "{type}/{meta}/{id}",
                defaults: new { controller = "Song", action = "SongDetail", id = UrlParameter.Optional },
                constraints: new { type = "Song" },
                        namespaces: new[] { "MusicApp.Controllers" }

            );

            routes.MapRoute(
                name: "Home",
                url: "",
                defaults: new { controller = "Home", action = "Index" },
                        namespaces: new[] { "MusicApp.Controllers" }

            );
            routes.MapRoute(
                name: "Song",
                url: "Song/{action}/{id}",
                defaults: new { controller = "Song", action = "Index", id = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }
            );
            routes.MapRoute(
                name: "Album",
                url: "Album/{action}/{id}",
                defaults: new { controller = "Album", action = "Index", id = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }

                );
            routes.MapRoute(
                name: "Event",
                url: "Event/{action}/{id}",
                defaults: new { controller = "Event", action = "Index", id = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }


            );

            routes.MapRoute(
                name: "Account",
                url: "Account/{action}/{id}",
                defaults: new { controller = "Account", action = "Index", id = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }

            );
            routes.MapRoute(
                 name: "AccountForm", 
                 url: "account/{formType}",
                 defaults: new { controller = "Account", action = "Index", formType = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }

             );

            routes.MapRoute(
                name: "Library",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Library", action = "Index", id = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }

            );
            routes.MapRoute(
                name: "Category",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Category", action = "Index", id = UrlParameter.Optional },
                        namespaces: new[] { "MusicApp.Controllers" }


            );
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
