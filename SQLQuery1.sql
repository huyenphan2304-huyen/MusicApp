
CREATE TABLE Album (
    AlbumID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(100),
    Artist NVARCHAR(100),
    Genre NVARCHAR(50),
    ImageURL NVARCHAR(255),
    Description NVARCHAR(255)
);0


INSERT INTO Album (Title, Artist, Genre, ImageURL, Description)
VALUES 
('The Cure', 'Second Song', 'Rock', '~/Content/img/bg-img/a1.jpg', 'The Cure Album'),
('Sam Smith', 'Underground', 'Pop', '~/Content/img/bg-img/a2.jpg', 'Sam Smith Album'),
('Will I am', 'First', 'Hip-hop', '~/Content/img/bg-img/a3.jpg', 'Will I am Album'),
('DJ SMITH', 'The Album', 'Electronic', '~/Content/img/bg-img/a5.jpg', 'DJ Smith Album'),
('Beyonce', 'Songs', 'Pop', '~/Content/img/bg-img/a7.jpg', 'Beyonce Album');

Drop table albums