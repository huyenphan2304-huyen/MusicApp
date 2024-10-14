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
('Home', '/Home', NULL),
('Album', '/Album', NULL),
('Event', '/Event', NULL),
('Category', 'Category', NULL),  -- Đây là menu chính, có các menu con
('Account', '/Account', NULL);

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
('Beyond Time', 'Artist A', 'Album 1', 'Pop', '2022-01-01', '/Content/img/bg-img/bg-1.jpg', '/Song/Play/1', 1, NULL),
('Colorlib Music', 'Artist B', 'Album 2', 'Rock', '2023-03-15', '/Content/img/bg-img/bg-2.jpg', '/Song/Play/2', 1, NULL),
('New Era', 'Artist C', 'Album 3', 'Jazz', '2024-05-21', '/Content/img/bg-img/bg-3.jpg', '/Song/Play/3', 0, NULL);


CREATE TABLE Contact (
    Id INT PRIMARY KEY IDENTITY(1,1),
    SectionTagline NVARCHAR(255) NOT NULL,
    SectionTitle NVARCHAR(255) NOT NULL,
    BackgroundImageUrl NVARCHAR(500),
    Hide BIT DEFAULT 0,
    [Order] INT DEFAULT 1,
    DateBegin DATE DEFAULT GETDATE()
);

INSERT INTO Contact (SectionTagline, SectionTitle, BackgroundImageUrl, Hide, [Order], DateBegin)
VALUES 
('See what’s new', 'Get In Touch', '/Content/img/bg-img/bg-2.jpg', 0, 1, '2024-10-10');


CREATE TABLE Miscellaneous (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(50) NOT NULL,             -- Loại mục (vd: Bài Hát Mới, Nghệ Sĩ Phổ Biến)
    Name NVARCHAR(255) NOT NULL,            -- Tên hiển thị
    Description NVARCHAR(MAX),               -- Mô tả cho bài hát hoặc nghệ sĩ
    Link NVARCHAR(500),                      -- Liên kết ngoài (nếu có)
    Meta NVARCHAR(255),                      -- Hiển thị trên địa chỉ của trình duyệt (SEO)
    Hide BIT NOT NULL DEFAULT 0,             -- Hiển thị hay ẩn đi (0: hiển thị, 1: ẩn)
    OrderPosition INT NOT NULL DEFAULT 0,    -- Vị trí xuất hiện
    DateBegin DATETIME DEFAULT GETDATE(),    -- Ngày tạo
    PText NVARCHAR(MAX),                      -- Nội dung cho thẻ <p>
    H2Text NVARCHAR(MAX),                     -- Nội dung cho thẻ <h2>
    ImageUrl NVARCHAR(500),                   -- Liên kết đến hình ảnh
    AudioUrl NVARCHAR(500)                    -- Liên kết đến audio
);

-- Chèn dữ liệu cho phần Tuần Tốt Nhất
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl) VALUES 
('Top', 'Sam Smith', 'Underground', NULL, 'sam-smith-underground', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt1.jpg', '/Content/audio/dummy-audio.mp3'),
('Top', 'Power Play', 'In my mind', NULL, 'power-play-in-my-mind', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt2.jpg', '/Content/audio/dummy-audio.mp3'),
('Top', 'Cristinne Smith', 'My Music', NULL, 'cristinne-smith-my-music', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt3.jpg', '/Content/audio/dummy-audio.mp3'),
('Top', 'The Music Band', 'Underground', NULL, 'the-music-band-underground', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt4.jpg', '/Content/audio/dummy-audio.mp3'),
('Top', 'Creative Lyrics', 'Songs and stuff', NULL, 'creative-lyrics-songs-and-stuff', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt5.jpg', '/Content/audio/dummy-audio.mp3'),
('Top', 'The Culture', 'Pop Songs', NULL, 'the-culture-pop-songs', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt6.jpg', '/Content/audio/dummy-audio.mp3');

-- Chèn dữ liệu cho phần Bài Hát Mới
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl) VALUES 
('NewHits', 'Sam Smith', 'Underground', NULL, 'sam-smith-underground', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt7.jpg', '/Content/audio/dummy-audio.mp3'),
('NewHits', 'Power Play', 'In my mind', NULL, 'power-play-in-my-mind', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt8.jpg', '/Content/audio/dummy-audio.mp3'),
('NewHits', 'Cristinne Smith', 'My Music', NULL, 'cristinne-smith-my-music', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt9.jpg', '/Content/audio/dummy-audio.mp3'),
('NewHits', 'The Music Band', 'Underground', NULL, 'the-music-band-underground', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt10.jpg', '/Content/audio/dummy-audio.mp3'),
('NewHits', 'Creative Lyrics', 'Songs and stuff', NULL, 'creative-lyrics-songs-and-stuff', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt11.jpg', '/Content/audio/dummy-audio.mp3'),
('NewHits', 'The Culture', 'Pop Songs', NULL, 'the-culture-pop-songs', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt12.jpg', '/Content/audio/dummy-audio.mp3');

-- Chèn dữ liệu cho phần Nghệ Sĩ Phổ Biến
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl) VALUES 
('PopularArtists', 'Sam Smith', NULL, NULL, 'sam-smith', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa1.jpg', NULL),
('PopularArtists', 'William Parker', NULL, NULL, 'william-parker', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa2.jpg', NULL),
('PopularArtists', 'Jessica Walsh', NULL, NULL, 'jessica-walsh', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa3.jpg', NULL),
('PopularArtists', 'Tha Stoves', NULL, NULL, 'tha-stoves', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa4.jpg', NULL),
('PopularArtists', 'DJ Ajay', NULL, NULL, 'dj-ajay', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa5.jpg', NULL),
('PopularArtists', 'Radio Vibez', NULL, NULL, 'radio-vibez', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa6.jpg', NULL),
('PopularArtists', 'Music 4u', NULL, NULL, 'music-4u', 0, 7, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa7.jpg', NULL);


CREATE TABLE Events (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Place NVARCHAR(255) NOT NULL,
    Date DATE NOT NULL,
    ImageUrl NVARCHAR(500),
    Description NVARCHAR(MAX),
    Meta NVARCHAR(255),
    Hide BIT,
    [Order] INT,
    DateBegin DATE
);

INSERT INTO Events (Title, Place, Date, ImageUrl, Description, Meta, Hide, [Order], DateBegin)
VALUES 
('Dj Night Party', 'VIP Sala', '2018-06-15', '/Content/img/bg-img/e1.jpg', 'Join us for an unforgettable night.', 'dj-night-party', 0, 1, '2018-06-01'),
('The Mission', 'Gold Arena', '2018-06-15', '/Content/img/bg-img/e2.jpg', 'Experience the best mission-themed party.', 'the-mission', 0, 2, '2018-06-01'),
('Planet Ibiza', 'Space Ibiza', '2018-06-15', '/Content/img/bg-img/e3.jpg', 'An Ibiza style event you don’t want to miss.', 'planet-ibiza', 0, 3, '2018-06-01'),
('Dj Night Party', 'VIP Sala', '2018-06-15', '/Content/img/bg-img/e4.jpg', 'Get ready for another epic DJ night!', 'dj-night-party-2', 0, 4, '2018-06-01'),
('The Mission', 'Gold Arena', '2018-06-15', '/Content/img/bg-img/e5.jpg', 'Another mission, another night of fun!', 'the-mission-2', 0, 5, '2018-06-01'),
('Planet Ibiza', 'Space Ibiza', '2018-06-15', '/Content/img/bg-img/e6.jpg', 'Ibiza vibes in full swing at Space.', 'planet-ibiza-2', 0, 6, '2018-06-01'),
('Dj Night Party', 'VIP Sala', '2018-06-15', '/Content/img/bg-img/e7.jpg', 'Yet another DJ night to party hard!', 'dj-night-party-3', 0, 7, '2018-06-01'),
('The Mission', 'Gold Arena', '2018-06-15', '/Content/img/bg-img/e8.jpg', 'A golden night at the Gold Arena.', 'the-mission-3', 0, 8, '2018-06-01'),
('Planet Ibiza', 'Space Ibiza', '2018-06-15', '/Content/img/bg-img/e9.jpg', 'Party like never before at Planet Ibiza.', 'planet-ibiza-3', 0, 9, '2018-06-01');


select * from menu

CREATE TABLE Breadcrumbs (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Subtitle NVARCHAR(255) NOT NULL,
    BackgroundImage NVARCHAR(500) NOT NULL
);

INSERT INTO Breadcrumbs (Title, Subtitle, BackgroundImage)
VALUES 
('Events', 'See what’s new', '/Content/img/bg-img/breadcumb3.jpg'),
('Concerts', 'Live Music Events', '/Content/img/bg-img/breadcumb4.jpg'),
('Festivals', 'Celebrating Together', '/Content/img/bg-img/breadcumb5.jpg');


CREATE TABLE Login (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255),
    EmailLabel NVARCHAR(255),
    EmailPlaceholder NVARCHAR(255),
    EmailHelpText NVARCHAR(255),
    PasswordLabel NVARCHAR(255),
    PasswordPlaceholder NVARCHAR(255),
    ButtonText NVARCHAR(255)
);

INSERT INTO Login (Title, EmailLabel, EmailPlaceholder, EmailHelpText, PasswordLabel, PasswordPlaceholder, ButtonText)
VALUES ('Welcome Back', 'Email address', 'Enter E-mail', 'We will never share your email with anyone else.', 'Password', 'Enter Password', 'Login');

CREATE TABLE Register (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255),
    NameLabel NVARCHAR(255),
    NamePlaceholder NVARCHAR(255),
    EmailLabel NVARCHAR(255),
    EmailPlaceholder NVARCHAR(255),
    PasswordLabel NVARCHAR(255),
    PasswordPlaceholder NVARCHAR(255),
    ButtonText NVARCHAR(255)
);

INSERT INTO Register (Title, NameLabel, NamePlaceholder, EmailLabel, EmailPlaceholder, PasswordLabel, PasswordPlaceholder, ButtonText)
VALUES ('Create Your Account', 'Full Name', 'Enter your full name', 'Email address', 'Enter your email', 'Password', 'Enter your password', 'Register');
