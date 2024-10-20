﻿using System.Web.Mvc;
using System.Web.Routing;

namespace MusicApp
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            // Route AlbumDetail cần đặt trước route Default
            routes.MapRoute(
                 name: "AlbumDetail",
                 url: "{type}/{meta}/{id}",
                 defaults: new { controller = "Album", action = "AlbumDetail", id = UrlParameter.Optional },
                 constraints: new { type = "album" } // Chỉ áp dụng route này cho 'album'
            );
            // Định nghĩa route cho EventDetail
            routes.MapRoute(
                name: "EventDetail",
                 url: "{type}/{meta}/{id}",
                defaults: new { controller = "Event", action = "EventDetail", id = UrlParameter.Optional },
                constraints: new { type = "event" } 
            );
            // Định nghĩa route cho SongDetail
            routes.MapRoute(
                name: "SongDetail",
                 url: "{type}/{meta}/{id}",
                defaults: new { controller = "Song", action = "SongDetail", id = UrlParameter.Optional },
                constraints: new { type = "Song" }
            );

            routes.MapRoute(
                name: "Home",
                url: "",
                defaults: new { controller = "Home", action = "Index" }
            );
            routes.MapRoute(
                name: "Song",
                url: "Song/{action}/{id}",
                defaults: new { controller = "Song", action = "Index", id = UrlParameter.Optional }
            );
            routes.MapRoute(
                name: "Event",
                url: "Event/{action}/{id}",
                defaults: new { controller = "Event", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Account",
                url: "Account/{action}/{id}",
                defaults: new { controller = "Account", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
