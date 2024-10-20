DECLARE @sql NVARCHAR(MAX) = N'';

-- Tạo câu lệnh DROP cho tất cả các bảng
SELECT @sql += 'DROP TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + '; '
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';

-- Thực hiện câu lệnh DROP
EXEC sp_executesql @sql;

drop table Songs
drop table Albums
drop table Artists

-- Tạo bảng Artists
CREATE TABLE Artists (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    ImageUrl NVARCHAR(500),
    BackgroundImageUrl NVARCHAR(500),
    Description NVARCHAR(MAX),
    Meta NVARCHAR(50) NULL,
    Hide BIT NULL,
    [Order] INT NULL,
    DateBegin SMALLDATETIME NULL
);
CREATE TABLE Category (
    Id INT PRIMARY KEY IDENTITY(1,1),  -- Khóa chính tự động tăng
    Name NVARCHAR(100) NOT NULL        -- Tên thể loại (category)
);

-- Tạo bảng Albums, tham chiếu đến bảng Artists
CREATE TABLE Albums (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Artist NVARCHAR(255) NOT NULL,
    CoverImageUrl NVARCHAR(500),
    Url NVARCHAR(500) NOT NULL,
    ReleaseDate DATE,
    ArtistId INT NULL,
    Meta NVARCHAR(50) NULL,
    Hide BIT NULL,
    [Order] INT NULL,
    DateBegin SMALLDATETIME NULL,
    CONSTRAINT FK_Albums_Artists FOREIGN KEY (ArtistId) REFERENCES Artists(Id)
);

-- Tạo bảng Songs
CREATE TABLE Songs (
    Id INT PRIMARY KEY IDENTITY(1,1),               -- Khóa chính, tự động tăng
    Title NVARCHAR(255) NOT NULL,                   -- Tiêu đề bài hát
    ArtistId INT NOT NULL,                          -- Khóa ngoại tham chiếu đến bảng Artists
    CategoryId INT NULL,                            -- Khóa ngoại tham chiếu đến bảng Category
    ReleaseDate DATE,                               -- Ngày phát hành
    CoverImageUrl NVARCHAR(500),                    -- Đường dẫn đến ảnh bìa
    Url NVARCHAR(500) NOT NULL,                     -- Đường dẫn đến tệp âm thanh
    IsFeatured BIT,                                 -- Đánh dấu bài hát nổi bật
    AlbumId INT NULL,                               -- Khóa ngoại tham chiếu đến bảng Albums (có thể null)
    Meta NVARCHAR(50) NULL,                         -- Thông tin meta
    Hide BIT NULL,                                  -- Trạng thái ẩn
    [Order] INT NULL,                               -- Thứ tự bài hát
    DateBegin SMALLDATETIME NULL,                   -- Ngày bắt đầu
    Lyrics NVARCHAR(MAX) NULL,                      -- Lời bài hát
    CONSTRAINT FK_Songs_Albums FOREIGN KEY (AlbumId) REFERENCES Albums(Id),   -- Ràng buộc khóa ngoại với bảng Albums
    CONSTRAINT FK_Songs_Artists FOREIGN KEY (ArtistId) REFERENCES Artists(Id), -- Ràng buộc khóa ngoại với bảng Artists
    CONSTRAINT FK_Songs_Category FOREIGN KEY (CategoryId) REFERENCES Category(Id) -- Ràng buộc khóa ngoại với bảng Category
);

-- Tạo bảng Menu
CREATE TABLE Menu (
    Id INT PRIMARY KEY IDENTITY(1,1),               -- Khóa chính, tự động tăng
    Name NVARCHAR(255) NOT NULL,                    -- Tên của menu
    Url NVARCHAR(500),                              -- Đường dẫn URL
    ParentId INT NULL,                              -- Khóa ngoại tham chiếu đến chính bảng Menu (menu cha)
    CategoryId INT NULL,                            -- Khóa ngoại tham chiếu đến bảng Category (nếu menu liên quan đến thể loại)
    Meta NVARCHAR(50) NULL,                         -- Thông tin meta
    Hide BIT NULL,                                  -- Trạng thái ẩn
    [Order] INT NULL,                               -- Thứ tự menu
    DateBegin SMALLDATETIME NULL,                   -- Ngày bắt đầu
    CONSTRAINT FK_Menu_Category FOREIGN KEY (CategoryId) REFERENCES Category(Id) -- Ràng buộc khóa ngoại với bảng Category
);


CREATE TABLE Contact (
    Id INT PRIMARY KEY IDENTITY(1,1),
    SectionTagline NVARCHAR(255) NOT NULL,
    SectionTitle NVARCHAR(255) NOT NULL,
    BackgroundImageUrl NVARCHAR(500),
    Hide BIT DEFAULT 0,
    [Order] INT DEFAULT 1,
    DateBegin DATE DEFAULT GETDATE()
);

CREATE TABLE Breadcrumbs (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Subtitle NVARCHAR(255) NOT NULL,
    BackgroundImage NVARCHAR(500) NOT NULL,
    Meta NVARCHAR(255),
    Hide BIT,
    [Order] INT,
    DateBegin DATE DEFAULT GETDATE()  
);

CREATE TABLE Miscellaneous (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Type NVARCHAR(50) NOT NULL,               -- Loại mục (vd: 'Top', 'NewHits')
    Name NVARCHAR(255) NOT NULL,              -- Tên hiển thị
    Description NVARCHAR(MAX),                 -- Mô tả
    Link NVARCHAR(500),                        -- Liên kết ngoài (nếu có)
    Meta NVARCHAR(255),                        -- Hiển thị trên URL (SEO)
    Hide BIT NOT NULL DEFAULT 0,               -- Hiển thị hay ẩn đi (0: hiển thị, 1: ẩn)
    OrderPosition INT NOT NULL DEFAULT 0,      -- Vị trí xuất hiện
    DateBegin DATETIME DEFAULT GETDATE(),      -- Ngày bắt đầu
    PText NVARCHAR(MAX),                       -- Nội dung cho thẻ <p>
    H2Text NVARCHAR(MAX),                      -- Nội dung cho thẻ <h2>
    ImageUrl NVARCHAR(500),                    -- Liên kết đến hình ảnh
    AudioUrl NVARCHAR(500),                    -- Liên kết đến audio
    SongId INT NULL,                           -- Khóa ngoại tham chiếu đến bảng Song (có thể null)
    ArtistId INT NULL,                         -- Khóa ngoại tham chiếu đến bảng Artist (có thể null)
    CONSTRAINT FK_Miscellaneous_Song FOREIGN KEY (SongId) REFERENCES Songs(Id),
    CONSTRAINT FK_Miscellaneous_Artist FOREIGN KEY (ArtistId) REFERENCES Artists(Id)
);


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
    DateBegin DATE DEFAULT GETDATE()  -- Thêm mặc định cho DateBegin
);
CREATE TABLE LoginForm (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255),
    EmailLabel NVARCHAR(255),
    EmailPlaceholder NVARCHAR(255),
    EmailHelpText NVARCHAR(255),
    PasswordLabel NVARCHAR(255),
    PasswordPlaceholder NVARCHAR(255),
    ButtonText NVARCHAR(255),
    Meta NVARCHAR(255),
    Hide BIT,
    [Order] INT,
    DateBegin DATE DEFAULT GETDATE()  
);
CREATE TABLE RegisterForm (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255),
    NameLabel NVARCHAR(255),
    NamePlaceholder NVARCHAR(255),
    EmailLabel NVARCHAR(255),
    EmailPlaceholder NVARCHAR(255),
    PasswordLabel NVARCHAR(255),
    PasswordPlaceholder NVARCHAR(255),
    ButtonText NVARCHAR(255),
    Meta NVARCHAR(255),
    Hide BIT,
    [Order] INT,
    DateBegin DATE DEFAULT GETDATE()  
);
CREATE TABLE BrowserCategories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(5),
    Filter NVARCHAR(10),
    Meta NVARCHAR(255),
    Hide BIT,
    [Order] INT,
    DateBegin DATE DEFAULT GETDATE()  
);

-- Thêm các thể loại vào bảng Category
INSERT INTO Category (Name) VALUES 
('Pop'), 
('Rock'), 
('Jazz'), 
('Hip Hop'), 
('Classical'), 
('Electronic');

-- Thêm menu chính
INSERT INTO Menu (Name, Url, ParentId, Meta, Hide, [Order], DateBegin) VALUES 
('Logo', '/Content/img/core-img/logo.png', NULL, 'logo', NULL, 1, GETDATE()),
('Home', '/Home', NULL, 'home', NULL, 2, GETDATE()),
('Album', '/Album', NULL, 'album', NULL, 3, GETDATE()),
('Event', '/Event', NULL, 'event', NULL, 4, GETDATE()),
('Category', '/Category', NULL, 'category', NULL, 5, GETDATE()),
('Account', '/Account', NULL, 'account', NULL, 6, GETDATE());

-- Thêm menu con cho Category và liên kết với bảng Category
INSERT INTO Menu (Name, Url, ParentId, CategoryId, Meta, Hide, [Order], DateBegin) 
VALUES 
('Pop', '/category/pop', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Pop'), 'pop', NULL, 1, GETDATE()),
('Rock', '/category/rock', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Rock'), 'rock', NULL, 2, GETDATE()),
('Jazz', '/category/jazz', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Jazz'), 'jazz', NULL, 3, GETDATE()),
('Hip Hop', '/category/hiphop', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), 'hiphop', NULL, 4, GETDATE()),
('Classical', '/category/classical', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Classical'), 'classical', NULL, 5, GETDATE()),
('Electronic', '/category/electronic', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Electronic'), 'electronic', NULL, 6, GETDATE());


-- Thêm nghệ sĩ
INSERT INTO Artists (Name, ImageUrl, BackgroundImageUrl, Description, Meta, Hide, [Order], DateBegin) VALUES
('Sam Smith', '/Content/img/bg-img/pa1.jpg', '/img/bg-img/bg-1.jpg', 'Nghệ sĩ nổi bật với nhiều ca khúc hit.', 'sam-smith', 0, 1, GETDATE()),
('William Parker', '/Content/img/bg-img/pa2.jpg', '/img/bg-img/bg-2.jpg', 'Nghệ sĩ đa tài, sở hữu nhiều album thành công.', 'william-parker', 0, 2, GETDATE()),
('Jessica Walsh', '/Content/img/bg-img/pa3.jpg', '/img/bg-img/bg-3.jpg', 'Nghệ sĩ mới nổi với phong cách âm nhạc độc đáo.', 'jessica-walsh', 0, 3, GETDATE()),
('Tha Stoves', '/Content/img/bg-img/pa4.jpg', '/img/bg-img/bg-4.jpg', 'Nghệ sĩ với nhiều phong cách độc đáo.', 'tha-stoves', 0, 4, GETDATE()),
('DJ Ajay', '/Content/img/bg-img/pa5.jpg', '/img/bg-img/bg-5.jpg', 'DJ nổi tiếng với nhiều bản remix hấp dẫn.', 'dj-ajay', 0, 5, GETDATE()),
('Radio Vibez', '/Content/img/bg-img/pa6.jpg', '/img/bg-img/bg-6.jpg', 'Nghệ sĩ mang âm hưởng sống động của âm nhạc hiện đại.', 'radio-vibez', 0, 6, GETDATE()),
('Music 4u', '/Content/img/bg-img/pa7.jpg', '/img/bg-img/bg-7.jpg', 'Nghệ sĩ trẻ trung với nhiều ca khúc vui tươi.', 'music-4u', 0, 7, GETDATE());

-- Thêm album
INSERT INTO Albums (Title, Artist, CoverImageUrl, Url, ReleaseDate, ArtistId, Meta, Hide, [Order], DateBegin) VALUES 
('The Cure', 'Second Song', '/Content/img/bg-img/a1.jpg', '/Album/Details/1', '2022-01-01', (SELECT Id FROM Artists WHERE Name = 'Sam Smith'), 'the-cure', 0, 1, GETDATE()),
('Sam Smith', 'Underground', '/Content/img/bg-img/a2.jpg', '/Album/Details/2', '2022-03-15', (SELECT Id FROM Artists WHERE Name = 'William Parker'), 'sam-smith-underground', 0, 2, GETDATE()),
('Will I Am', 'First', '/Content/img/bg-img/a3.jpg', '/Album/Details/3', '2023-05-21', (SELECT Id FROM Artists WHERE Name = 'Jessica Walsh'), 'will-i-am', 0, 3, GETDATE()),
('The Cure', 'Second Song', '/Content/img/bg-img/a4.jpg', '/Album/Details/4', '2023-07-19', (SELECT Id FROM Artists WHERE Name = 'Tha Stoves'), 'the-cure-2', 0, 4, GETDATE()),
('DJ Smith', 'The Album', '/Content/img/bg-img/a5.jpg', '/Album/Details/5', '2024-08-12', (SELECT Id FROM Artists WHERE Name = 'DJ Ajay'), 'dj-smith-the-album', 0, 5, GETDATE()),
('The Unstoppable', 'Unplugged', '/Content/img/bg-img/a6.jpg', '/Album/Details/6', '2024-09-25', (SELECT Id FROM Artists WHERE Name = 'Radio Vibez'), 'the-unstoppable-unplugged', 0, 6, GETDATE()),
('Beyonce', 'Songs', '/Content/img/bg-img/a7.jpg', '/Album/Details/7', '2024-10-01', (SELECT Id FROM Artists WHERE Name = 'Music 4u'), 'beyonce-songs', 0, 7, GETDATE());

-- Thêm bài hát 
-- Thêm bài hát với CategoryId liên kết từ bảng Category
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics) VALUES 
('Beyond Time', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2022-01-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'beyond-time', 0, 1, GETDATE(), 
'Walking away
In the soft rain
Chasing the sun
With dreams so high
Love in the air
Hearts beat as one
Time flies so fast
Moments we share
Under the stars
Together we rise'),
('Underground', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2022-03-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'underground', 0, 2, GETDATE(),
'Walking away
In the soft rain
Chasing the sun
With dreams so high
Love in the air
Hearts beat as one
Time flies so fast
Moments we share
Under the stars
Together we rise'),
('First', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2023-05-21', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'first', 0, 3, GETDATE(),
'Walking away
In the soft rain
Chasing the sun
With dreams so high
Love in the air
Hearts beat as one
Time flies so fast
Moments we share
Under the stars
Together we rise'),
('Second Song', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Tha Stoves'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2023-07-19', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'second-song', 0, 4, GETDATE(),
'Walking away
In the soft rain
Chasing the sun
With dreams so high
Love in the air
Hearts beat as one
Time flies so fast
Moments we share
Under the stars
Together we rise'),
('The Album', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2024-08-12', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'the-album', 0, 5, GETDATE(),
'Walking away
In the soft rain
Chasing the sun
With dreams so high
Love in the air
Hearts beat as one
Time flies so fast
Moments we share
Under the stars
Together we rise');

INSERT INTO Contact (SectionTagline, SectionTitle, BackgroundImageUrl, Hide, [Order], DateBegin)
VALUES 
('See what’s new', 'Get In Touch', '/Content/img/bg-img/bg-2.jpg', 0, 1, GETDATE());  -- Sử dụng GETDATE() để lấy ngày hiện tại

-- Chèn dữ liệu cho phần Bài Hát Mới
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl, SongId, ArtistId) VALUES 
('NewHits', 'Echoes of Silence', 'A heartfelt ballad from Sam Smith.', NULL, 'echoes-of-silence', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/a1.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Echoes of Silence'), 
    (SELECT Id FROM Songs WHERE Title = 'Echoes of Silence'), 
    (SELECT Id FROM Artists WHERE Name = 'Sam Smith')),
('NewHits', 'Midnight Dreams', 'A song that brings colorful dreams to life.', NULL, 'midnight-dreams', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/a2.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Midnight Dreams'), 
    (SELECT Id FROM Songs WHERE Title = 'Midnight Dreams'), 
    (SELECT Id FROM Artists WHERE Name = 'William Parker')),
('NewHits', 'Chasing Stars', 'A gentle and soulful jazz tune.', NULL, 'chasing-stars', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/a3.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Chasing Stars'), 
    (SELECT Id FROM Songs WHERE Title = 'Chasing Stars'), 
    (SELECT Id FROM Artists WHERE Name = 'Jessica Walsh')),
('NewHits', 'Rhythm of the Night', 'An energetic R&B track that will get you moving.', NULL, 'rhythm-of-the-night', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/a4.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Rhythm of the Night'), 
    (SELECT Id FROM Songs WHERE Title = 'Rhythm of the Night'), 
    (SELECT Id FROM Artists WHERE Name = 'Tha Stoves')),
('NewHits', 'Remix Magic', 'An amazing remix by DJ Ajay.', NULL, 'remix-magic', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/a5.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Remix Magic'), 
    (SELECT Id FROM Songs WHERE Title = 'Remix Magic'), 
    (SELECT Id FROM Artists WHERE Name = 'DJ Ajay')),
('NewHits', 'Unforgettable Moments', 'A wonderful song from Radio Vibez.', NULL, 'unforgettable-moments', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/a6.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Unforgettable Moments'), 
    (SELECT Id FROM Songs WHERE Title = 'Unforgettable Moments'), 
    (SELECT Id FROM Artists WHERE Name = 'Radio Vibez')),
('NewHits', 'Harmonious Vibes', 'A cheerful track from Music 4u.', NULL, 'harmonious-vibes', 0, 7, GETDATE(), NULL, NULL, '/Content/img/bg-img/a7.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Harmonious Vibes'), 
    (SELECT Id FROM Songs WHERE Title = 'Harmonious Vibes'), 
    (SELECT Id FROM Artists WHERE Name = 'Music 4u'));

-- Chèn dữ liệu cho phần Top
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl, SongId, ArtistId) VALUES 
('Top', 'Beyond Time', 'A standout song by Sam Smith.', NULL, 'beyond-time', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/a1.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Beyond Time'), 
    (SELECT Id FROM Songs WHERE Title = 'Beyond Time'), 
    (SELECT Id FROM Artists WHERE Name = 'Sam Smith')),
('Top', 'Colorlib Music', 'A lively rock anthem.', NULL, 'colorlib-music', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/a2.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Colorlib Music'), 
    (SELECT Id FROM Songs WHERE Title = 'Colorlib Music'), 
    (SELECT Id FROM Artists WHERE Name = 'William Parker')),
('Top', 'New Era', 'A fresh and unique jazz piece.', NULL, 'new-era', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/a3.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'New Era'), 
    (SELECT Id FROM Songs WHERE Title = 'New Era'), 
    (SELECT Id FROM Artists WHERE Name = 'Jessica Walsh')),
('Top', 'Rhythm of the Night', 'A fantastic song from Tha Stoves.', NULL, 'rhythm-of-the-night', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/a4.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Rhythm of the Night'), 
    (SELECT Id FROM Songs WHERE Title = 'Rhythm of the Night'), 
    (SELECT Id FROM Artists WHERE Name = 'Tha Stoves')),
('Top', 'Remix Magic', 'An outstanding remix by DJ Ajay.', NULL, 'remix-magic', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/a5.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Remix Magic'), 
    (SELECT Id FROM Songs WHERE Title = 'Remix Magic'), 
    (SELECT Id FROM Artists WHERE Name = 'DJ Ajay')),
('Top', 'Unforgettable Moments', 'A fantastic track from Radio Vibez.', NULL, 'unforgettable-moments', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/a6.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE Title = 'Unforgettable Moments'), 
    (SELECT Id FROM Songs WHERE Title = 'Unforgettable Moments'), 
    (SELECT Id FROM Artists WHERE Name = 'Radio Vibez'));

-- Chèn dữ liệu cho phần Nghệ Sĩ Phổ Biến
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl, SongId, ArtistId) VALUES 
('PopularArtists', 'Sam Smith', 'A prominent artist with many hit songs.', 'sam-smith', 'sam-smith', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa1.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'Sam Smith')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'Sam Smith')),
('PopularArtists', 'William Parker', 'A multi-talented artist with several successful albums.', 'william-parker', 'william-parker', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa2.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'William Parker')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'William Parker')),
('PopularArtists', 'Jessica Walsh', 'An emerging artist with a unique musical style.', 'jessica-walsh', 'jessica-walsh', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa3.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'Jessica Walsh')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'Jessica Walsh')),
('PopularArtists', 'Tha Stoves', 'An artist with many distinctive styles.', 'tha-stoves', 'tha-stoves', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa4.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'Tha Stoves')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'Tha Stoves')),
('PopularArtists', 'DJ Ajay', 'A famous DJ known for numerous remixes.', 'dj-ajay', 'dj-ajay', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa5.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'DJ Ajay')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'DJ Ajay')),
('PopularArtists', 'Radio Vibez', 'An artist with many relaxing tracks.', 'radio-vibez', 'radio-vibez', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa6.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'Radio Vibez')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'Radio Vibez')),
('PopularArtists', 'Music 4u', 'An artist with many energetic songs.', 'music-4u', 'music-4u', 0, 7, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa7.jpg', 
    (SELECT TOP 1 Url FROM Songs WHERE ArtistId = (SELECT Id FROM Artists WHERE Name = 'Music 4u')), 
    NULL, (SELECT Id FROM Artists WHERE Name = 'Music 4u'));


INSERT INTO Events (Title, Place, Date, ImageUrl, Description, Meta, Hide, [Order], DateBegin)
VALUES 
('Dj Night Party', 'VIP Sala', '2018-06-15', '/Content/img/bg-img/e1.jpg', 'Join us for an unforgettable night.', 'dj-night-party', 0, 1, GETDATE()),
('The Mission', 'Gold Arena', '2018-06-15', '/Content/img/bg-img/e2.jpg', 'Experience the best mission-themed party.', 'the-mission', 0, 2, GETDATE()),
('Planet Ibiza', 'Space Ibiza', '2018-06-15', '/Content/img/bg-img/e3.jpg', 'An Ibiza style event you don’t want to miss.', 'planet-ibiza', 0, 3, GETDATE()),
('Dj Night Party', 'VIP Sala', '2018-06-15', '/Content/img/bg-img/e4.jpg', 'Get ready for another epic DJ night!', 'dj-night-party-2', 0, 4, GETDATE()),
('The Mission', 'Gold Arena', '2018-06-15', '/Content/img/bg-img/e5.jpg', 'Another mission, another night of fun!', 'the-mission-2', 0, 5, GETDATE()),
('Planet Ibiza', 'Space Ibiza', '2018-06-15', '/Content/img/bg-img/e6.jpg', 'Ibiza vibes in full swing at Space.', 'planet-ibiza-2', 0, 6, GETDATE()),
('Dj Night Party', 'VIP Sala', '2018-06-15', '/Content/img/bg-img/e7.jpg', 'Yet another DJ night to party hard!', 'dj-night-party-3', 0, 7, GETDATE()),
('The Mission', 'Gold Arena', '2018-06-15', '/Content/img/bg-img/e8.jpg', 'Join the best mission-themed party yet.', 'the-mission-3', 0, 8, GETDATE()),
('Planet Ibiza', 'Space Ibiza', '2018-06-15', '/Content/img/bg-img/e9.jpg', 'Ibiza magic awaits!', 'planet-ibiza-3', 0, 9, GETDATE());


select * from menu



INSERT INTO Breadcrumbs (Title, Subtitle, BackgroundImage)
VALUES 
('Events', 'See what’s new', '/Content/img/bg-img/breadcumb3.jpg'),
('Concerts', 'Live Music Events', '/Content/img/bg-img/breadcumb4.jpg'),
('Festivals', 'Celebrating Together', '/Content/img/bg-img/breadcumb5.jpg');


INSERT INTO LoginForm (Title, EmailLabel, EmailPlaceholder, EmailHelpText, PasswordLabel, PasswordPlaceholder, ButtonText)
VALUES ('Welcome Back', 'Email address', 'Enter E-mail', 'We will never share your email with anyone else.', 'Password', 'Enter Password', 'Login');



INSERT INTO RegisterForm (Title, NameLabel, NamePlaceholder, EmailLabel, EmailPlaceholder, PasswordLabel, PasswordPlaceholder, ButtonText)
VALUES ('Create Your Account', 'Full Name', 'Enter your full name', 'Email address', 'Enter your email', 'Password', 'Enter your password', 'Register');







-- Thêm dữ liệu từ A-Z
DECLARE @char CHAR(1);
SET @char = 'A';

-- Chạy vòng lặp chỉ từ A-Z
WHILE ASCII(@char) <= ASCII('Z')
BEGIN
    INSERT INTO BrowserCategories (Name, Filter)
    VALUES (@char, LOWER(@char));
    
    -- Chuyển sang ký tự tiếp theo trong bảng chữ cái
    SET @char = CHAR(ASCII(@char) + 1);
END

-- Thêm mục '0-9'
INSERT INTO BrowserCategories (Name, Filter)
VALUES ('0-9', 'number');

select * from Songs
--select * from Register
--select * from Albums
select * from Miscellaneous




