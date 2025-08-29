-- Struktur SQL dari JSON

-- Tabel utama courses
CREATE TABLE courses (
    id VARCHAR(50) PRIMARY KEY,
    createdAt DATETIME,
    creatorId VARCHAR(50),
    title VARCHAR(255),
    imageUrl TEXT,
    videoUrl TEXT,
    content TEXT
);

-- Tabel creatorData (relasi ke courses)
CREATE TABLE creatorData (
    courseId VARCHAR(50),
    username VARCHAR(100),
    email VARCHAR(255),
    createdAt DATETIME,
    PRIMARY KEY(courseId),
    FOREIGN KEY(courseId) REFERENCES courses(id)
);
