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
-------------------
CREATE TABLE Projects(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
)
------------------
CREATE TABLE ScientificWorks(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	NumberOfQuotes INT,
	ReleaseDate TIMESTAMP NOT NULL,
	UsedInProjectId INT REFERENCES Projects(Id)
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
--1-- RADI
--naziv i datum objave svakog znanstvenog rada zajedno s imenima znanstvenika koji su na njemu radili, 
--pri čemu imena znanstvenika moraju biti u jednoj ćeliji i u obliku Prezime, I.; npr. Puljak, I.; Godinović, N.; Bilušić, A.
SELECT sw.Name, sw.ReleaseDate, STRING_AGG(CONCAT(s.Surname, ', ', LEFT(s.Name, 1)), '; ') FROM ScientificWorks sw 
JOIN ScientistScientificWork ssw ON ssw.ScientificWorkId=sw.Id
JOIN Scientists s ON s.Id=ssw.ScientistId
GROUP BY sw.Name, sw.ReleaseDate

--2-- RADI
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

--3--RADI
--svaku kombinaciju projekta i akceleratora, pri čemu nas zanimaju samo nazivi; 
--u slučaju da projekt nije vezan ni za jedan akcelerator, svejedno ga ispiši uz ime akceleratora ‘NEMA GA’.
SELECT p.Name, 
COALESCE((SELECT STRING_AGG(a.Name, ' ') FROM Accelerators a 
		 JOIN AcceleratorProject ap ON a.Id=ap.AcceleratorId
		 JOIN Projects ps ON ap.ProjectId=ps.Id
		WHERE ps.Id=p.Id
		), 'None') AS Acc
FROM Projects p
ORDER BY p.Name

--4-- RADI
--sve projekte kojima je bar jedan od radova izašao između 2015. i 2017.
SELECT p.Name FROM Projects p 
JOIN ScientificWorks sw ON sw.UsedInProjectId=p.Id
WHERE DATE_PART('year', sw.ReleaseDate)>2014 AND DATE_PART('year', sw.ReleaseDate)<2017

--5-- RADI
--u istoj tablici po zemlji broj radova i najpopularniji rad znanstvenika iste zemlje, 
--pri čemu je najpopularniji rad onaj koji ima najviše citata
SELECT c.Name, COUNT(sw.Id),
CAST((SELECT swn.Name FROM ScientificWorks swn
	JOIN ScientistScientificWork sswn ON sswn.ScientificWorkId=swn.Id
	JOIN Scientists sn ON sn.Id=sswn.ScientistId
	JOIN Countries cn ON cn.Id=sn.CountryId
	WHERE c.Name=cn.Name
	ORDER BY swn.NumberOfQuotes DESC
	LIMIT 1) AS VARCHAR)
FROM Countries c
JOIN Scientists s ON s.CountryId=c.Id
JOIN ScientistScientificWork ssw ON ssw.ScientistId=s.Id
JOIN ScientificWorks sw ON sw.Id=ssw.ScientificWorkId
GROUP BY c.Name

--6--prvi objavljeni rad po svakoj zemlji
SELECT DISTINCT ON(c.Name) c.Name, sw.Name, sw.ReleaseDate FROM Countries c
JOIN Scientists s ON s.CountryId=c.Id
JOIN ScientistScientificWork ssw ON ssw.ScientistId=s.Id
JOIN ScientificWorks sw ON sw.Id=ssw.ScientificWorkId
ORDER BY c.Name, sw.ReleaseDate

--7--gradove po broju znanstvenika koji trenutno u njemu borave
SELECT h.City, COUNT(s.Id) AS NumberOfScientists FROM Hotels h
FULL JOIN Scientists s ON s.HotelId=h.Id
GROUP BY h.City
ORDER BY COUNT(s.Id) DESC

--8--prosječan broj citata radova po svakom akceleratoru
SELECT a.Name, ROUND(AVG(sw.NumberOfQuotes), 2) FROM Accelerators a
JOIN AcceleratorProject ap ON ap.AcceleratorId=a.Id
JOIN Projects p ON p.Id=ap.ProjectId
JOIN ScientificWorks sw ON p.Id=sw.UsedInProjectId
GROUP BY a.Name
ORDER BY a.Name

--9--broj znanstvenika po struci, desetljeću rođenja i spolu; 
--u slučaju da je broj znanstvenika manji od 20, ne prikazuj kategoriju; 
--poredaj prikaz po desetljeću rođenja
SELECT DISTINCT ON(s.Profession) s.Profession, COUNT(s.Profession), COUNT(EXTRACT(DECADE FROM s.BirthDate)), s.Gender FROM Scientists s
GROUP BY s.Profession, s.Gender, s.BirthDate
ORDER BY s.Profession,EXTRACT(DECADE FROM s.BirthDate)
--ok kod--
SELECT c.Name, COUNT(sw.Id) FROM Countries c
JOIN Scientists s ON s.CountryId=c.Id
JOIN ScientistScientificWork ssw ON ssw.ScientistId=s.Id
JOIN ScientificWorks sw ON sw.Id=ssw.ScientificWorkId
GROUP BY c.Name

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
(default, 'Marija', 'Bliznac Trebjesanin', '1975-11-30', '2', 'developer', 2, 3),
(default, 'Darko', 'Vujica', '2000-10-10', '1', 'developer', 3, 1)

INSERT INTO Projects(Id, Name) VALUES
(default, 'projekt1'),
(default, 'projekt2'),
(default, 'projekt3'),
(default, 'projekt4'),
(default, 'projekt5')

INSERT INTO ScientificWorks(Id, Name, NumberOfQuotes, ReleaseDate, UsedInProjectId) VALUES
(default, 'Logaritamska funkcija', 30, '2010-5-6', 1),
(default, 'Funkcije', 10, '2011-5-10', 1),
(default, 'Bozja cestica', 25, '2015-10-6', 2)

INSERT INTO ScientistScientificWork(ScientistId,ScientificWorkId ) VALUES
(1, 1),
(2, 1),
(1, 2),
(3, 2),
(1, 3),
(2, 3),
(3, 3)

INSERT INTO Accelerators(Id, Name) VALUES
(default, 'accelerator1'),
(default, 'accelerator2'),
(default, 'accelerator3'),
(default, 'accelerator4'),
(default, 'accelerator5'),
(default, 'accelerator6')

INSERT INTO AcceleratorProject(AcceleratorId, ProjectId) VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 2),
(4, 1),
(4, 2),
(4, 3),
(5, 1),
(5, 2),
(6, 1)