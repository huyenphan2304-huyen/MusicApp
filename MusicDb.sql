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
drop table category

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
    IsFavorite BIT,                                 -- Đánh dấu bài hát yêu thích

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

INSERT INTO Category (Name) VALUES 
('Reggae'), 
('Country'), 
('Blues'), 
('Folk'), 
('Metal');

-- Thêm menu chính
INSERT INTO Menu (Name, Url, ParentId, Meta, Hide, [Order], DateBegin) VALUES 
('Logo', '/Content/img/core-img/logo.png', NULL, 'logo', NULL, 1, GETDATE()),
('Home', '/Home', NULL, 'home', NULL, 2, GETDATE()),
('Album', '/Album', NULL, 'album', NULL, 3, GETDATE()),
('Event', '/Event', NULL, 'event', NULL, 4, GETDATE()),
('Category', '/Category', NULL, 'category', NULL, 5, GETDATE()),
('Library', '/Library', NULL, 'account', NULL, 6, GETDATE());

-- Thêm menu con cho Category và liên kết với bảng Category
INSERT INTO Menu (Name, Url, ParentId, CategoryId, Meta, Hide, [Order], DateBegin) 
VALUES 
('Pop', '/category/pop', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Pop'), 'pop', NULL, 1, GETDATE()),
('Rock', '/category/rock', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Rock'), 'rock', NULL, 2, GETDATE()),
('Jazz', '/category/jazz', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Jazz'), 'jazz', NULL, 3, GETDATE()),
('Hip Hop', '/category/hiphop', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), 'hiphop', NULL, 4, GETDATE()),
('Classical', '/category/classical', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Classical'), 'classical', NULL, 5, GETDATE()),
('Electronic', '/category/electronic', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Electronic'), 'electronic', NULL, 6, GETDATE());

-- Thêm menu con cho Category
INSERT INTO Menu (Name, Url, ParentId, CategoryId, Meta, Hide, [Order], DateBegin) 
VALUES 
('Reggae', '/category/reggae', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Reggae'), 'reggae', NULL, 7, GETDATE()),
('Country', '/category/country', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Country'), 'country', NULL, 8, GETDATE()),
('Blues', '/category/blues', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Blues'), 'blues', NULL, 9, GETDATE()),
('Folk', '/category/folk', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Folk'), 'folk', NULL, 10, GETDATE()),
('Metal', '/category/metal', (SELECT Id FROM Menu WHERE Name = 'Category'), (SELECT Id FROM Category WHERE Name = 'Metal'), 'metal', NULL, 11, GETDATE());

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
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) 
VALUES 
('Beyond Time', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2022-01-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'beyond-time', 0, 1, GETDATE(), 
'Walking away...', 1), -- IsFavorite = 1 (ngẫu nhiên)
('Underground', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2022-03-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'underground', 0, 2, GETDATE(), 
'Walking away...', 0), -- IsFavorite = 0 (ngẫu nhiên)
('First', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2023-05-21', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'first', 0, 3, GETDATE(), 
'Walking away...', 1), -- IsFavorite = 1 (ngẫu nhiên)
('Second Song', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Tha Stoves'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2023-07-19', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'second-song', 0, 4, GETDATE(), 
'Walking away...', 0), -- IsFavorite = 0 (ngẫu nhiên)
('The Album', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2024-08-12', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'the-album', 0, 5, GETDATE(), 
'Walking away...', 1); -- IsFavorite = 1 (ngẫu nhiên)
-- Thêm bài hát cho thể loại Reggae
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) 
VALUES 
('Island Breeze', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Reggae'), '2022-06-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'island-breeze', 0, 1, GETDATE(), 
'Feel the rhythm...', 0), -- IsFavorite = 0 (ngẫu nhiên)
('Sunshine Melody', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Reggae'), '2022-07-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'sunshine-melody', 0, 2, GETDATE(), 
'In the sunshine...', 1), -- IsFavorite = 1 (ngẫu nhiên)
('Dancing in the Rain', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Reggae'), '2023-03-10', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Unstoppable'), 'dancing-in-the-rain', 0, 3, GETDATE(), 
'Let the raindrops...', 0), -- IsFavorite = 0 (ngẫu nhiên)
('Reggae Nights', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Reggae'), '2023-08-20', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'reggae-nights', 0, 4, GETDATE(), 
'Under the stars...', 1), -- IsFavorite = 1 (ngẫu nhiên)
('Good Vibes Only', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Tha Stoves'), (SELECT Id FROM Category WHERE Name = 'Reggae'), '2024-09-10', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'good-vibes-only', 0, 5, GETDATE(), 
'Good vibes only...', 0); -- IsFavorite = 0 (ngẫu nhiên)

-- Thêm bài hát cho thể loại Country
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) 
VALUES 
('Country Roads', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Country'), '2022-05-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'country-roads', 0, 1, GETDATE(), 
'Take me home...', 1), -- IsFavorite = 1 (ngẫu nhiên)
('Southern Nights', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Country'), '2022-06-10', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'southern-nights', 0, 2, GETDATE(), 
'In the southern...', 0), -- IsFavorite = 0 (ngẫu nhiên)
('Boots and Jeans', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Country'), '2023-05-21', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'boots-and-jeans', 0, 3, GETDATE(), 
'With my boots...', 1), -- IsFavorite = 1 (ngẫu nhiên)
('Whiskey on the Rocks', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Tha Stoves'), (SELECT Id FROM Category WHERE Name = 'Country'), '2023-07-19', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'whiskey-on-the-rocks', 0, 4, GETDATE(), 
'Pour me a whiskey...', 0), -- IsFavorite = 0 (ngẫu nhiên)
('Love in the Country', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Country'), '2024-08-12', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'love-in-the-country', 1, 5, GETDATE(), 
'With a heart full...', 1); -- IsFavorite = 1 (ngẫu nhiên)
-- Thêm bài hát cho thể loại Blues
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Midnight Blues', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Blues'), '2022-02-28', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'midnight-blues', 0, 1, GETDATE(), 
'When the night falls, I feel the pain
With the midnight blues running through my veins
In this solitude, I’ll find my way
Through the shadows, I will stay', 0),
('Blues for You', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Blues'), '2022-03-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'blues-for-you', 0, 2, GETDATE(),
'This blues is for you, my dear
In every note, I’ll dry your tears
With the sound of sorrow and joy
In this melody, our hearts will enjoy', 1),
('Lost in the City', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Blues'), '2023-06-01', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'lost-in-the-city', 0, 3, GETDATE(),
'In the city lights, I feel so small
With the blues surrounding, I hear the call
Through the alleys and streets, I’ll find my song
In this city, I’ll learn to be strong', 0),
('Long Road Ahead', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Blues'), '2023-07-20', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'long-road-ahead', 0, 4, GETDATE(),
'The road is long, but I’ll keep going
With the blues in my heart, I’ll keep on flowing
Through the trials and the endless night
In this journey, I’ll find the light', 0),
('Bluesy Night', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Blues'), '2024-09-01', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'bluesy-night', 0, 5, GETDATE(),
'In the bluesy night, we will sway
With the stars above, we’ll drift away
Through the music and the dreams we’ll find
In this moment, we are intertwined', 1);

-- Thêm bài hát cho thể loại Folk
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Folk Tales', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Folk'), '2022-01-12', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'folk-tales', 0, 1, GETDATE(), 
'Tales of old, in the warm glow
With every word, our hearts will grow
Through the stories and the dreams we’ll weave
In this folk song, we will believe', 1),
('Nature’s Song', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Folk'), '2022-02-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'natures-song', 0, 2, GETDATE(),
'In the forest, I hear the call
With nature’s song, we’ll stand tall
Through the trees and the rivers wide
In this folk tale, we’ll take pride', 0),
('Heart of the Earth', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Folk'), '2023-03-30', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'heart-of-the-earth', 0, 3, GETDATE(),
'With every beat, I feel the earth
In this melody, I find my worth
Through the valleys and the hills we’ll roam
In this folk song, we will find home', 0),
('Sunset Dreams', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Tha Stoves'), (SELECT Id FROM Category WHERE Name = 'Folk'), '2023-05-21', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'sunset-dreams', 0, 4, GETDATE(),
'As the sun sets, we’ll find our way
In this dream, we’ll dance and sway
Through the colors of the evening sky
In this folk song, we will fly', 0),
('Voices of the Wind', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Folk'), '2024-09-15', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'voices-of-the-wind', 0, 5, GETDATE(),
'In the wind, I hear the song
With every whisper, we belong
Through the echoes of time and space
In this folk melody, we find grace', 1);

-- Thêm bài hát cho thể loại Metal
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Metal Fury', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Tha Stoves'), (SELECT Id FROM Category WHERE Name = 'Metal'), '2022-09-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'metal-fury', 0, 1, GETDATE(), 
'Feel the fury, feel the fire
With every riff, we’ll take it higher
In this metal storm, we will stand
With our fists raised high, united we band', 1),
('Iron Will', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Metal'), '2022-10-10', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'iron-will', 0, 2, GETDATE(),
'With an iron will, I’ll never break
In this metal journey, I’ll never shake
Through the darkness and the endless night
With every note, we’ll find our light', 0),
('Heavy Metal Heart', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Metal'), '2023-05-21', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'heavy-metal-heart', 0, 3, GETDATE(),
'With a heavy heart, I scream and shout
In this metal world, there’s no doubt
Through the chaos and the noise we’ll thrive
In this metal anthem, we feel alive', 0),
('Shattered Dreams', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Metal'), '2023-07-19', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'shattered-dreams', 0, 4, GETDATE(),
'In the ashes of dreams, we rise again
With the power of metal, we’ll transcend
Through the battles and the scars we wear
In this metal journey, we’ll find our share', 1),
('Metal Night', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Metal'), '2024-09-15', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'metal-night', 0, 5, GETDATE(),
'In the night of metal, we’ll unite
With the sound of thunder, we’ll take flight
Through the echoes and the raging sound
In this metal anthem, we’ll be found', 0);

-- Thêm bài hát cho thể loại Pop
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Pop Dreams', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2022-01-05', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'pop-dreams', 0, 1, GETDATE(), 
'In this pop dream, we’ll fly so high
With the rhythm of life, we’ll touch the sky
Through the beats and the melodies sweet
In this pop song, our hearts will meet', 1),
('Summer Vibes', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Sam Smith'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2022-06-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'summer-vibes', 0, 2, GETDATE(),
'With the summer sun, we’ll dance and play
In the warm breeze, we’ll drift away
Through the laughter and the joy we’ll find
In this pop melody, we’ll unwind', 1),
('Heartbeat', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2023-05-21', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'heartbeat', 0, 3, GETDATE(),
'In every heartbeat, I feel the sound
With the pop rhythm, we’re glory-bound
Through the moments that make us whole
In this pop anthem, we’ll find our soul', 0),
('Dancing in the Rain', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2023-07-30', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'dancing-in-the-rain', 0, 4, GETDATE(),
'In the rain, we’ll dance and sing
With the pop magic, our hearts will ring
Through the storm and the sunny days
In this pop journey, we’ll find our ways', 1),
('Euphoria', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Pop'), '2024-09-10', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'DJ Smith'), 'euphoria', 0, 5, GETDATE(),
'In this euphoria, we’ll find our light
With the pop rhythm, we’ll take flight
Through the beats and the joy we’ll share
In this pop melody, we’ll always care', 0);

-- Thêm bài hát cho thể loại Rock
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Rocking the Night', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Rock'), '2022-01-20', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'rocking-the-night', 0, 1, GETDATE(), 
'We’ll rock the night, we’ll shake the ground,
With every riff, we’ll turn it around.
In the heart of the storm, we’ll stand tall,
In this rock anthem, we’ll give it our all.', 1),
('Electric Fire', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Rock'), '2022-02-25', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'electric-fire', 0, 2, GETDATE(),
'Feel the electric fire, burning bright,
With every chord, we’ll ignite the night.
Through the chaos, we’ll find our way,
In this rock journey, we’ll forever stay.', 0),
('Heart of Rock', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Rock'), '2023-04-10', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'heart-of-rock', 0, 3, GETDATE(),
'With the heart of rock, we’ll never fall,
In this music, we’ll give our all.
Through the rhythms and the beats we’ll thrive,
In this rock anthem, we’ll feel alive.', 0),
('Wild Nights', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Rock'), '2023-07-15', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Unstoppable'), 'wild-nights', 0, 4, GETDATE(),
'In the wild nights, we’ll run free,
With the music echoing through the trees.
Through the fire and the thunder we’ll roam,
In this rock song, we’ll find our home.', 1),
('Rock Your Soul', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Rock'), '2024-08-30', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'rock-your-soul', 0, 5, GETDATE(),
'With every note, we’ll rock your soul,
In this melody, we’ll take control.
Through the passion and the fire we’ll rise,
In this rock anthem, we’ll touch the skies.', 1);

-- Thêm bài hát cho thể loại Jazz
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Smooth Jazz Nights', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Jazz'), '2022-03-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'smooth-jazz-nights', 0, 1, GETDATE(), 
'Smooth jazz nights, with a gentle breeze,
Through the melodies, we’ll find our peace.
In the glow of the moon, we’ll sway and glide,
In this jazz dream, we’ll take pride.', 1),
('Jazz It Up', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Jazz'), '2022-03-15', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'jazz-it-up', 0, 2, GETDATE(),
'Jazz it up, let the music flow,
With every note, we’ll let it show.
Through the rhythm and the swing we’ll find,
In this jazz song, we’ll unwind.', 0),
('Night in Jazz', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Jazz'), '2023-05-10', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'night-in-jazz', 0, 3, GETDATE(),
'In the night, we’ll find our way,
With the jazz notes leading us to play.
Through the city lights and the stars above,
In this jazz rhythm, we’ll find love.', 0),
('Jazz Breeze', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Jazz'), '2023-06-20', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Unstoppable'), 'jazz-breeze', 0, 4, GETDATE(),
'Feel the jazz breeze, soft and sweet,
With every note, we’ll move our feet.
Through the melodies, we’ll dance and sway,
In this jazz moment, we’ll forever stay.', 1),
('Jazz Dreams', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Jazz'), '2024-09-10', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'jazz-dreams', 0, 5, GETDATE(),
'In jazz dreams, we’ll find our light,
With every note, we’ll take flight.
Through the rhythms and the harmonies we’ll glide,
In this jazz melody, we’ll confide.', 0);

-- Thêm bài hát cho thể loại Hip Hop
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Hip Hop Beats', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), '2022-01-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'hip-hop-beats', 0, 1, GETDATE(), 
'With hip hop beats, we’ll feel the flow,
Through the rhythm, we’ll steal the show.
In the streets, we’ll make our mark,
In this hip hop anthem, we’ll spark.', 1),
('Street Life', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), '2022-01-20', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'street-life', 0, 2, GETDATE(),
'In the street life, we’ll find our way,
With every lyric, we’ll seize the day.
Through the hustle and the grind we’ll thrive,
In this hip hop journey, we’ll come alive.', 0),
('Rhythm and Rhyme', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), '2023-04-01', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'rhythm-and-rhyme', 0, 3, GETDATE(),
'With rhythm and rhyme, we’ll tell our tale,
In this hip hop world, we will prevail.
Through the beats and the stories we’ll flow,
In this hip hop anthem, we’ll steal the show.', 0),
('Voices from the Streets', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), '2023-05-01', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Unstoppable'), 'voices-from-the-streets', 0, 4, GETDATE(),
'Voices from the streets, we’ll rise high,
With the rhythm and the truth, we’ll touch the sky.
In the beats of our hearts, we’ll find our song,
In this hip hop journey, we’ll belong.', 1),
('Hip Hop Revolution', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Hip Hop'), '2024-06-15', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'hip-hop-revolution', 0, 5, GETDATE(),
'In the hip hop revolution, we’ll stand tall,
With the music guiding us, we’ll never fall.
Through the rhythms and the beats, we’ll thrive,
In this hip hop anthem, we’ll come alive.', 0);

-- Thêm bài hát cho thể loại Classical
INSERT INTO Songs (Title, ArtistId, CategoryId, ReleaseDate, CoverImageUrl, Url, IsFeatured, AlbumId, Meta, Hide, [Order], DateBegin, Lyrics, IsFavorite) VALUES 
('Classical Dreams', (SELECT TOP 1 Id FROM Artists WHERE Name = 'William Parker'), (SELECT Id FROM Category WHERE Name = 'Classical'), '2022-04-01', '/Content/img/bg-img/a1.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Cure'), 'classical-dreams', 0, 1, GETDATE(), 
'In classical dreams, we’ll soar high,
With every note, we’ll touch the sky.
Through the symphonies and the sonatas we’ll play,
In this classical world, we’ll find our way.', 1),
('Melody of the Night', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Jessica Walsh'), (SELECT Id FROM Category WHERE Name = 'Classical'), '2022-04-20', '/Content/img/bg-img/a2.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Sam Smith'), 'melody-of-the-night', 0, 2, GETDATE(),
'With the melody of the night, we’ll dance,
In this classical realm, we’ll take our chance.
Through the harmonies and the chords we’ll glide,
In this classical moment, we’ll take pride.', 0),
('Whispers of the Wind', (SELECT TOP 1 Id FROM Artists WHERE Name = 'DJ Ajay'), (SELECT Id FROM Category WHERE Name = 'Classical'), '2023-08-01', '/Content/img/bg-img/a3.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Will I Am'), 'whispers-of-the-wind', 0, 3, GETDATE(),
'In the whispers of the wind, we’ll find our peace,
Through the classical notes, our souls will release.
With every chord, we’ll make our mark,
In this classical journey, we’ll ignite the spark.', 0),
('Elegance in Strings', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Radio Vibez'), (SELECT Id FROM Category WHERE Name = 'Classical'), '2023-09-01', '/Content/img/bg-img/a4.jpg', '/Content/audio/dummy-audio.mp3', 0, (SELECT TOP 1 Id FROM Albums WHERE Title = 'The Unstoppable'), 'elegance-in-strings', 0, 4, GETDATE(),
'With elegance in strings, we’ll dance in time,
In this classical world, we’ll find our rhyme.
Through the melodies and the soft embrace,
In this classical song, we’ll find our place.', 1),
('Timeless Classics', (SELECT TOP 1 Id FROM Artists WHERE Name = 'Music 4u'), (SELECT Id FROM Category WHERE Name = 'Classical'), '2024-10-01', '/Content/img/bg-img/a5.jpg', '/Content/audio/dummy-audio.mp3', 1, (SELECT TOP 1 Id FROM Albums WHERE Title = 'Beyonce'), 'timeless-classics', 0, 5, GETDATE(),
'In timeless classics, we’ll find our song,
With every note, we’ll sing along.
Through the orchestras and the echoes we’ll glide,
In this classical moment, we’ll take pride.', 0);

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
('Concerts', 'Live Music Events', '/Content/img/bg-img/breadcumb3.jpg'),
('Festivals', 'Celebrating Together', '/Content/img/bg-img/breadcumb3.jpg'),
('Album', 'Discover new music', '/Content/img/bg-img/breadcumb3.jpg'),
('Category', 'Browse by genre', '/Content/img/bg-img/breadcumb3.jpg'),
('Library', 'Your favorite collection', '/Content/img/bg-img/breadcumb3.jpg');

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


CREATE TABLE AspNetUsers (
    Id UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    Email NVARCHAR(256) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(256) NULL,
    SecurityStamp NVARCHAR(256) NULL,
    UserName NVARCHAR(256) NOT NULL,
);

-- Tạo bảng Users để lưu thông tin người dùng
CREATE TABLE Users (
    Id INT PRIMARY KEY IDENTITY(1,1),           -- Khóa chính tự động tăng
    Username NVARCHAR(50) NOT NULL,             -- Tên người dùng
    Email NVARCHAR(100) NOT NULL UNIQUE,        -- Địa chỉ email người dùng
    CreatedDate DATETIME DEFAULT GETDATE()       -- Ngày tạo tài khoản
);

-- Thêm dữ liệu mẫu vào bảng Users
INSERT INTO Users (Username, Email)
VALUES 
('user1', 'user1@example.com'),
('user2', 'user2@example.com'),
('user3', 'user3@example.com');

-- Tạo bảng Playlists để lưu thông tin playlist
CREATE TABLE Playlists (
    Id INT PRIMARY KEY IDENTITY(1,1),             -- Khóa chính tự động tăng
    PlaylistName NVARCHAR(255) NOT NULL,          -- Tên playlist
    PlaylistDescription NVARCHAR(MAX) NULL,       -- Mô tả playlist
    UserId INT NOT NULL,                          -- Khóa ngoại tham chiếu đến bảng Users (người tạo playlist)
    CreatedDate DATETIME DEFAULT GETDATE(),       -- Ngày tạo playlist
    CONSTRAINT FK_Playlists_Users FOREIGN KEY (UserId) REFERENCES Users(Id) -- Ràng buộc với bảng Users
);
-- Tạo bảng PlaylistSongs để lưu mối quan hệ giữa Playlists và Songs
CREATE TABLE PlaylistSongs (
    PlaylistId INT NOT NULL,                     -- Khóa ngoại tham chiếu đến bảng Playlists
    SongId INT NOT NULL,                         -- Khóa ngoại tham chiếu đến bảng Songs
    AddedDate DATETIME DEFAULT GETDATE(),        -- Ngày bài hát được thêm vào playlist
    PRIMARY KEY (PlaylistId, SongId),            -- Khóa chính là cặp (PlaylistId, SongId)
    CONSTRAINT FK_PlaylistSongs_Playlists FOREIGN KEY (PlaylistId) REFERENCES Playlists(Id),  -- Ràng buộc với Playlists
    CONSTRAINT FK_PlaylistSongs_Songs FOREIGN KEY (SongId) REFERENCES Songs(Id) -- Ràng buộc với Songs
);
-- Thêm dữ liệu mẫu vào bảng Playlists
INSERT INTO Playlists (PlaylistName, PlaylistDescription, UserId)
VALUES 
('Road Trip', 'Perfect songs for a long drive', 1),
('Party Hits', 'Best tracks to pump up your party', 2),
('Relaxing Vibes', 'Chill and unwind with these songs', 1),
('Workout Mix', 'Energetic songs to keep you going', 3);

-- Thêm dữ liệu mẫu vào bảng PlaylistSongs
INSERT INTO PlaylistSongs (PlaylistId, SongId)
VALUES 
-- Playlist 'Road Trip' với các bài hát
(1, 1),  -- Bài hát 1 trong playlist 'Road Trip'
(1, 2),  -- Bài hát 2 trong playlist 'Road Trip'
(1, 3),  -- Bài hát 3 trong playlist 'Road Trip'

-- Playlist 'Party Hits' với các bài hát
(2, 4),  -- Bài hát 4 trong playlist 'Party Hits'
(2, 5),  -- Bài hát 5 trong playlist 'Party Hits'
(2, 6),  -- Bài hát 6 trong playlist 'Party Hits'

-- Playlist 'Relaxing Vibes' với các bài hát
(3, 7),  -- Bài hát 7 trong playlist 'Relaxing Vibes'
(3, 8),  -- Bài hát 8 trong playlist 'Relaxing Vibes'
(3, 9),  -- Bài hát 9 trong playlist 'Relaxing Vibes'

-- Playlist 'Workout Mix' với các bài hát
(4, 10), -- Bài hát 10 trong playlist 'Workout Mix'
(4, 11), -- Bài hát 11 trong playlist 'Workout Mix'
(4, 12); -- Bài hát 12 trong playlist 'Workout Mix'

select * from Events


CREATE TABLE Slides (
    Id INT PRIMARY KEY IDENTITY(1,1),
    AlbumId INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (AlbumId) REFERENCES Albums(Id),
    Meta NVARCHAR(50) NULL,
    Hide BIT NULL,
    [Order] INT NULL,
    DateBegin SMALLDATETIME NULL

);

Drop table Slides
