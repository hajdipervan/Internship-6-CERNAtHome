---------DROP---------
DROP TABLE Accelerators CASCADE
DROP TABLE Projects CASCADE
DROP TABLE AcceleratorProject
DROP TABLE Scientists CASCADE
DROP TABLE ScientificWorks CASCADE
DROP TABLE ScientistScientificWork
DROP TABLE Countries CASCADE
DROP TABLE Hotels
---------BAZE---------
CREATE TABLE Accelerators(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)
------------------
CREATE TABLE ScientificWorks(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	NumberOfQuotes INT,
	ReleaseDate TIMESTAMP NOT NULL
)
-------------------
CREATE TABLE Projects(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	ScientificWorkId INT REFERENCES ScientificWorks(Id)
)
-------------------
CREATE TABLE AcceleratorProject(
	AcceleratorId INT REFERENCES Accelerators(Id),
	ProjectId INT REFERENCES Projects(Id)
)
-------------------
CREATE TABLE Countries(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(52) UNIQUE NOT NULL,
	Population INT NOT NULL
	--PPP_Capita ??
)
-------------------
CREATE TABLE Hotels(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Capacity INT NOT NULL,
	City VARCHAR(30) NOT NULL
)
-------------------
CREATE TABLE Scientists(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	BirthDate TIMESTAMP NOT NULL,
	Gender VARCHAR(1) CHECK (Gender IN ('0','1','2','9')),
	Profession VARCHAR(19) CHECK (Profession IN ('developer', 'physicist', 'engineer', 'material scientist')),
	CountryId INT REFERENCES Countries(Id) NOT NULL,
	HotelId INT REFERENCES Hotels(Id)
)
-------------------
CREATE TABLE ScientistScientificWork(
	ScientistId INT REFERENCES Scientists(Id),
	ScientificWorkId INT REFERENCES ScientificWorks(Id)
)
-------------------
-------------------
-------PRINT-------
--1--
--naziv i datum objave svakog znanstvenog rada zajedno s imenima znanstvenika koji su na njemu radili, 
--pri čemu imena znanstvenika moraju biti u jednoj ćeliji i u obliku Prezime, I.; npr. Puljak, I.; Godinović, N.; Bilušić, A.
SELECT sw.Name, sw.ReleaseDate, STRING_AGG(CONCAT(s.Surname, ', ', LEFT(s.Name, 1)), '; ') FROM ScientificWorks sw 
JOIN ScientistScientificWork ssw ON ssw.ScientificWorkId=sw.Id
JOIN Scientists s ON s.Id=ssw.ScientistId
GROUP BY sw.Name, sw.ReleaseDate

--2--
--ime, prezime, spol (ispisati ‘MUŠKI’, ‘ŽENSKI’, ‘NEPOZNATO’, ‘OSTALO’;), ime države i  PPP/capita iste svakom znanstveniku--
SELECT s.Name, s.Surname,
CASE WHEN s.Gender='0' THEN 'Not known'
WHEN s.Gender='1' THEN 'Male'
WHEN s.Gender='2' THEN 'Female'
WHEN s.Gender='9' THEN 'Not applicable'
END AS Gender,
c.Name AS Country
FROM Scientists s
JOIN Countries c ON c.Id=s.CountryId
--DODAJ OVAJ PPP?

--3--
--
SELECT * FROM Hotels
SELECT * FROM Countries
SELECT * FROM Scientists
SELECT * FROM ScientificWorks
SELECT * FROM ScientistScientificWork

INSERT INTO Hotels(Id,Name, Capacity, City) VALUES
(default, 'Sheraton', 2000, 'Zagreb'),
(default, 'Radisson', 2000, 'Split'),
(default, 'Supetar', 2000, 'Brac')

INSERT INTO Countries(Id, Name, Population) VALUES
(default, 'Croatia', 4500000),
(default, 'BIH', 8000000),
(default, 'Slovenia', 3500000)

INSERT INTO Scientists(Id, Name, Surname, BirthDate, Gender, Profession, CountryId, HotelId) VALUES
(default, 'Ivica', 'Puljak', '1970-08-30', '1', 'physicist', 1, 1),
(default, 'Marija', 'Bliznac Trebjesanin', '1975-11-30', '2', 'engineer', 2, 3),
(default, 'Darko', 'Vujica', '2000-10-10', '1', 'developer', 3, 1)

INSERT INTO ScientificWorks(Id, Name, NumberOfQuotes, ReleaseDate) VALUES
(default, 'Logaritamska funkcija', 30, '2010-5-6'),
(default, 'Funkcije', 20, '2011-5-10'),
(default, 'Bozja cestica', 25, '2015-10-6')

INSERT INTO ScientistScientificWork(ScientistId,ScientificWorkId ) VALUES
(1, 1),
(2, 1),
(1, 2),
(3, 2),
(1, 3),
(2, 3),
(3, 3)