CREATE TABLE Menu (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Url NVARCHAR(200),
    ParentId INT NULL
);

-- Thêm menu chính
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Logo', '/Content/img/core-img/logo.png', NULL);
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Home', '/Views/Home/index.cshtml', NULL);
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Albums', '/Views/Home/albums-store.cshtml', NULL);
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Events', '/Views/Home/event.cshtml', NULL);
INSERT INTO Menu (Name, Url, ParentId) VALUES ('News', '/Views/Home/blog.cshtml', NULL);
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Contact', '/Views/Home/contact.cshtml', NULL);
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Account', '/Views/Home/login.cshtml', NULL);

-- Thêm menu con cho "Pages"
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Pages', '#', NULL); -- Đây là menu chính, có các menu con
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Home', '/Views/Home/index.cshtml', (SELECT Id FROM Menu WHERE Name = 'Pages'));
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Albums', '/Views/Home/albums-store.cshtml', (SELECT Id FROM Menu WHERE Name = 'Pages'));
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Events', '/Views/Home/event.cshtml', (SELECT Id FROM Menu WHERE Name = 'Pages'));
INSERT INTO Menu (Name, Url, ParentId) VALUES ('News', '/Views/Home/blog.cshtml', (SELECT Id FROM Menu WHERE Name = 'Pages'));
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Contact', '/Views/Home/contact.cshtml', (SELECT Id FROM Menu WHERE Name = 'Pages'));
INSERT INTO Menu (Name, Url, ParentId) VALUES ('Login', '/Views/Home/login.cshtml', (SELECT Id FROM Menu WHERE Name = 'Pages'));

-- Tạo bảng Songs
CREATE TABLE Songs (
    Id INT PRIMARY KEY IDENTITY(1,1),   -- Khóa chính với auto increment
    Title NVARCHAR(255) NOT NULL,       -- Tên bài hát
    Artist NVARCHAR(255) NOT NULL,      -- Tên nghệ sĩ
    Album NVARCHAR(255),                -- Album của bài hát
    Genre NVARCHAR(100),                -- Thể loại nhạc
    ReleaseDate DATE,                   -- Ngày phát hành
    CoverImageUrl NVARCHAR(500),        -- Đường dẫn ảnh bìa
    Url NVARCHAR(500),                  -- Đường dẫn bài hát
    IsFeatured BIT                      -- Bài hát có phải là nổi bật hay không
);

-- Thêm dữ liệu cho bảng Songs
INSERT INTO Songs (Title, Artist, Album, Genre, ReleaseDate, CoverImageUrl, Url, IsFeatured)
VALUES 
('Beyond Time', 'Artist A', 'Album 1', 'Pop', '2022-01-01', '/Content/img/bg-img/bg-1.jpg', '/Song/Play/1', 1),
('Colorlib Music', 'Artist B', 'Album 2', 'Rock', '2023-03-15', '/Content/img/bg-img/bg-2.jpg', '/Song/Play/2', 1),
('New Era', 'Artist C', 'Album 3', 'Jazz', '2024-05-21', '/Content/img/bg-img/bg-3.jpg', '/Song/Play/3', 0);
