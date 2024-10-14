
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
('See what’s new', 'Get In Touch', '/img/bg-img/bg-2.jpg', 0, 1, '2024-10-10');



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
('Top', 'Sam Smith', 'Underground', NULL, 'sam-smith-underground', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt1.jpg', '/audio/dummy-audio.mp3'),
('Top', 'Power Play', 'In my mind', NULL, 'power-play-in-my-mind', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt2.jpg', '/audio/dummy-audio.mp3'),
('Top', 'Cristinne Smith', 'My Music', NULL, 'cristinne-smith-my-music', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt3.jpg', '/audio/dummy-audio.mp3'),
('Top', 'The Music Band', 'Underground', NULL, 'the-music-band-underground', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt4.jpg', '/audio/dummy-audio.mp3'),
('Top', 'Creative Lyrics', 'Songs and stuff', NULL, 'creative-lyrics-songs-and-stuff', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt5.jpg', '/audio/dummy-audio.mp3'),
('Top', 'The Culture', 'Pop Songs', NULL, 'the-culture-pop-songs', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt6.jpg', '/audio/dummy-audio.mp3');

-- Chèn dữ liệu cho phần Bài Hát Mới
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl) VALUES 
('NewHits', 'Sam Smith', 'Underground', NULL, 'sam-smith-underground', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt7.jpg', '/audio/dummy-audio.mp3'),
('NewHits', 'Power Play', 'In my mind', NULL, 'power-play-in-my-mind', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt8.jpg', '/audio/dummy-audio.mp3'),
('NewHits', 'Cristinne Smith', 'My Music', NULL, 'cristinne-smith-my-music', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt9.jpg', '/audio/dummy-audio.mp3'),
('NewHits', 'The Music Band', 'Underground', NULL, 'the-music-band-underground', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt10.jpg', '/audio/dummy-audio.mp3'),
('NewHits', 'Creative Lyrics', 'Songs and stuff', NULL, 'creative-lyrics-songs-and-stuff', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt11.jpg', '/audio/dummy-audio.mp3'),
('NewHits', 'The Culture', 'Pop Songs', NULL, 'the-culture-pop-songs', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/wt12.jpg', '/audio/dummy-audio.mp3');

-- Chèn dữ liệu cho phần Nghệ Sĩ Phổ Biến
INSERT INTO Miscellaneous (Type, Name, Description, Link, Meta, Hide, OrderPosition, DateBegin, PText, H2Text, ImageUrl, AudioUrl) VALUES 
('PopularArtists', 'Sam Smith', NULL, NULL, 'sam-smith', 0, 1, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa1.jpg', NULL),
('PopularArtists', 'William Parker', NULL, NULL, 'william-parker', 0, 2, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa2.jpg', NULL),
('PopularArtists', 'Jessica Walsh', NULL, NULL, 'jessica-walsh', 0, 3, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa3.jpg', NULL),
('PopularArtists', 'Tha Stoves', NULL, NULL, 'tha-stoves', 0, 4, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa4.jpg', NULL),
('PopularArtists', 'DJ Ajay', NULL, NULL, 'dj-ajay', 0, 5, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa5.jpg', NULL),
('PopularArtists', 'Radio Vibez', NULL, NULL, 'radio-vibez', 0, 6, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa6.jpg', NULL),
('PopularArtists', 'Music 4u', NULL, NULL, 'music-4u', 0, 7, GETDATE(), NULL, NULL, '/Content/img/bg-img/pa7.jpg', NULL);
