-- Tạo bảng Artists trước vì nó được tham chiếu trong bảng Albums
CREATE TABLE Artists (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    ImageUrl NVARCHAR(500),
    BackgroundImageUrl NVARCHAR(500),
    Description NVARCHAR(MAX)
);

-- Tạo bảng Albums, tham chiếu đến bảng Artists
CREATE TABLE Albums (
    Id INT PRIMARY KEY IDENTITY(1,1),  -- Khóa chính với auto increment
    Title NVARCHAR(255) NOT NULL,      -- Tên album
    Artist NVARCHAR(255) NOT NULL,     -- Tên nghệ sĩ
    CoverImageUrl NVARCHAR(500),        -- Đường dẫn ảnh bìa album
    Url NVARCHAR(500) NOT NULL,         -- Đường dẫn đến trang chi tiết album
    ReleaseDate DATE,                   -- Ngày phát hành album
    ArtistId INT NULL,                  -- Khóa ngoại đến bảng Artists
    CONSTRAINT FK_Albums_Artists FOREIGN KEY (ArtistId) REFERENCES Artists(Id)
);

-- Tạo bảng Songs, tham chiếu đến bảng Albums
CREATE TABLE Songs (
    Id INT PRIMARY KEY IDENTITY(1,1),   -- Khóa chính với auto increment
    Title NVARCHAR(255) NOT NULL,       -- Tên bài hát
    Artist NVARCHAR(255) NOT NULL,      -- Tên nghệ sĩ
    Album NVARCHAR(255),                 -- Album của bài hát
    Genre NVARCHAR(100),                 -- Thể loại nhạc
    ReleaseDate DATE,                    -- Ngày phát hành
    CoverImageUrl NVARCHAR(500),         -- Đường dẫn ảnh bìa
    Url NVARCHAR(500) NOT NULL,          -- Đường dẫn bài hát
    IsFeatured BIT,                      -- Bài hát có phải là nổi bật hay không
    AlbumId INT NULL,                    -- Khóa ngoại đến bảng Albums
    CONSTRAINT FK_Songs_Albums FOREIGN KEY (AlbumId) REFERENCES Albums(Id)
);

-- Tạo bảng Menu
CREATE TABLE Menu (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,      -- Tên menu
    Url NVARCHAR(200) NOT NULL,       -- Đường dẫn menu
    ParentId INT NULL,                 -- Khóa ngoại chỉ đến menu cha
    CONSTRAINT FK_Menu_Parent FOREIGN KEY (ParentId) REFERENCES Menu(Id)
);

-- Thêm menu chính
INSERT INTO Menu (Name, Url, ParentId) VALUES 
('Logo', '/Content/img/core-img/logo.png', NULL),
('Home', '/home', NULL),
('Album', '/albums', NULL),
('Event', '/events', NULL),
('Category', '#', NULL),  -- Đây là menu chính, có các menu con
('Account', '/account', NULL);

-- Thêm menu con cho "Category"
INSERT INTO Menu (Name, Url, ParentId) VALUES 
('Pop', '/category/pop', (SELECT Id FROM Menu WHERE Name = 'Category')),
('Rock', '/category/rock', (SELECT Id FROM Menu WHERE Name = 'Category')),
('Jazz', '/category/jazz', (SELECT Id FROM Menu WHERE Name = 'Category')),
('Hip Hop', '/category/hiphop', (SELECT Id FROM Menu WHERE Name = 'Category')),
('Classical', '/category/classical', (SELECT Id FROM Menu WHERE Name = 'Category')),
('Electronic', '/category/electronic', (SELECT Id FROM Menu WHERE Name = 'Category'));

-- Thêm nghệ sĩ
INSERT INTO Artists (Name, ImageUrl, BackgroundImageUrl, Description) VALUES
('Sam Smith', '/Content/img/bg-img/pa1.jpg', '/img/bg-img/bg-1.jpg', 'Nghệ sĩ nổi bật với nhiều ca khúc hit.'),
('William Parker', '/Content/img/bg-img/pa2.jpg', '/img/bg-img/bg-2.jpg', 'Nghệ sĩ đa tài, sở hữu nhiều album thành công.'),
('Jessica Walsh', '/Content/img/bg-img/pa3.jpg', '/img/bg-img/bg-3.jpg', 'Nghệ sĩ mới nổi với phong cách âm nhạc độc đáo.'),
('Tha Stoves', '/Content/img/bg-img/pa4.jpg', '/img/bg-img/bg-4.jpg', 'Nghệ sĩ với nhiều phong cách độc đáo.'),
('DJ Ajay', '/Content/img/bg-img/pa5.jpg', '/img/bg-img/bg-5.jpg', 'DJ nổi tiếng với nhiều bản remix hấp dẫn.'),
('Radio Vibez', '/Content/img/bg-img/pa6.jpg', '/img/bg-img/bg-6.jpg', 'Nghệ sĩ mang âm hưởng sống động của âm nhạc hiện đại.'),
('Music 4u', '/Content/img/bg-img/pa7.jpg', '/img/bg-img/bg-7.jpg', 'Nghệ sĩ trẻ trung với nhiều ca khúc vui tươi.');

-- Thêm album
INSERT INTO Albums (Title, Artist, CoverImageUrl, Url, ReleaseDate, ArtistId) VALUES 
('The Cure', 'Second Song', '/Content/img/bg-img/a1.jpg', '/Album/Details/1', '2022-01-01', (SELECT Id FROM Artists WHERE Name = 'Sam Smith')),
('Sam Smith', 'Underground', '/Content/img/bg-img/a2.jpg', '/Album/Details/2', '2022-03-15', (SELECT Id FROM Artists WHERE Name = 'William Parker')),
('Will I Am', 'First', '/Content/img/bg-img/a3.jpg', '/Album/Details/3', '2023-05-21', (SELECT Id FROM Artists WHERE Name = 'Jessica Walsh')),
('The Cure', 'Second Song', '/Content/img/bg-img/a4.jpg', '/Album/Details/4', '2023-07-19', (SELECT Id FROM Artists WHERE Name = 'Tha Stoves')),
('DJ Smith', 'The Album', '/Content/img/bg-img/a5.jpg', '/Album/Details/5', '2024-08-12', (SELECT Id FROM Artists WHERE Name = 'DJ Ajay')),
('The Unstoppable', 'Unplugged', '/Content/img/bg-img/a6.jpg', '/Album/Details/6', '2024-09-25', (SELECT Id FROM Artists WHERE Name = 'Radio Vibez')),
('Beyonce', 'Songs', '/Content/img/bg-img/a7.jpg', '/Album/Details/7', '2024-10-01', (SELECT Id FROM Artists WHERE Name = 'Music 4u'));

-- Thêm bài hát
INSERT INTO Songs (Title, Artist, Album, Genre, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId)
VALUES 
('Beyond Time', 'Artist A', 'Album 1', 'Pop', '2022-01-01', '/img/bg-img/bg-1.jpg', '/Song/Play/1', 1, NULL),
('Colorlib Music', 'Artist B', 'Album 2', 'Rock', '2023-03-15', '/img/bg-img/bg-2.jpg', '/Song/Play/2', 1, NULL),
('New Era', 'Artist C', 'Album 3', 'Jazz', '2024-05-21', '/img/bg-img/bg-3.jpg', '/Song/Play/3', 0, NULL);

