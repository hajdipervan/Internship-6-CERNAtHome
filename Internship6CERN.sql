--backup--
---------DROP---------
DROP TABLE Accelerators CASCADE;
DROP TABLE Projects CASCADE;
DROP TABLE AcceleratorProject;
DROP TABLE Scientists CASCADE;
DROP TABLE ScientificWorks CASCADE;
DROP TABLE ScientistScientificWork;
DROP TABLE Countries CASCADE;
DROP TABLE Hotels CASCADE;
----Bases and constraints----
CREATE TABLE Accelerators(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
);
CREATE TABLE Projects(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
);
CREATE TABLE ScientificWorks(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	NumberOfQuotes INT,
	ReleaseDate TIMESTAMP NOT NULL,
	UsedInProjectId INT REFERENCES Projects(Id)
);
ALTER TABLE ScientificWorks
	ADD CONSTRAINT UniqueNameForSW UNIQUE(Name),
	ADD CONSTRAINT CheckReleaseDate CHECK(ReleaseDate<Now());
CREATE TABLE AcceleratorProject(
	AcceleratorId INT REFERENCES Accelerators(Id),
	ProjectId INT REFERENCES Projects(Id)
);
CREATE TABLE Countries(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(52) NOT NULL,
	Population INT NOT NULL,
	PPPCapita FLOAT NOT NULL
);
ALTER TABLE Countries
	ADD CONSTRAINT UniqueNameForCountry UNIQUE(Name);
CREATE TABLE Hotels(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Capacity INT NOT NULL,
	City VARCHAR(30) NOT NULL
);
ALTER TABLE Hotels
	ADD CONSTRAINT UniqueHotelNameForCity UNIQUE(Name, City),
	ADD CONSTRAINT CheckCapacity CHECK (Capacity>Id);
CREATE TABLE Scientists(
	Id SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Surname VARCHAR(30) NOT NULL,
	BirthDate TIMESTAMP NOT NULL,
	Gender VARCHAR(1),
	Profession VARCHAR(19),
	CountryId INT REFERENCES Countries(Id) NOT NULL,
	HotelId INT REFERENCES Hotels(Id) NOT NULL
);
ALTER TABLE Scientists
	ADD CONSTRAINT CheckBirthDate CHECK(BirthDate<Now()),
	ADD CONSTRAINT CheckGender CHECK (Gender IN ('0','1','2','9')),
	ADD CONSTRAINT CheckProfession CHECK (Profession IN ('developer', 'physicist', 'engineer', 'material scientist'));
CREATE TABLE ScientistScientificWork(
	ScientistId INT REFERENCES Scientists(Id),
	ScientificWorkId INT REFERENCES ScientificWorks(Id)
);
------INSERTS------
INSERT INTO Hotels(Id,Name, Capacity, City) VALUES
(default, 'Charming Geneva', 500, 'Geneva'),
(default, 'Radisson', 700, 'Split'),
(default, 'Supetar', 150, 'Brac'),
(default, 'Park', 100, 'Split'),
(default, 'Hvar', 50, 'Jelsa');

INSERT INTO Countries(Id, Name, Population, PPPCapita) VALUES
(default, 'Croatia', 4500000, 33800.6),
(default, 'BIH', 8000000, 16846.5),
(default, 'Slovenia', 3500000, 43624.7),
(default, 'Germany', 83000000, 57927.6);

INSERT INTO Scientists(Id, Name, Surname, BirthDate, Gender, Profession, CountryId, HotelId) VALUES
(default, 'Ivica', 'Puljak', '1970-08-30', '1', 'physicist', 1, 1),
(default, 'Marija', 'Bliznac Trebjesanin', '1975-11-30', '2', 'developer', 2, 3),
(default, 'Darko', 'Vujica', '2000-10-10', '1', 'developer', 3, 1),
(default, 'Mia', 'Vujica', '1972-10-10', '2', 'developer', 3, 1),
(default, 'Mila', 'Vujica', '1970-10-10', '2', 'developer', 3, 4),
(default, 'Mi', 'Vujica', '1970-10-10', '9', 'developer', 3, 4),
(default, 'Ivo', 'Puljak', '1970-08-30', '1', 'developer', 1, 1),
(default, 'Ivan', 'Puljak', '2000-08-30', '0', 'developer', 1, 1),
(default, 'Nikola', 'Koceic Bilan', '1970-08-20', '1', 'engineer', 1, 1),
(default, 'Snjezana', 'Braic', '1980-11-30', '2', 'developer', 1, 1),
(default, 'Ivan', 'Jelic', '1972-10-10', '1', 'developer', 3, 1),
(default, 'Domagoj', 'Jelic', '1974-10-10', '1', 'developer', 3, 4),
(default, 'Mislav', 'Baric', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Tomislav', 'Bilic', '1971-08-30', '1', 'developer', 1, 1),
(default, 'Toni', 'Puljak', '1977-08-30', '1', 'developer', 1, 1),
(default, 'Ivan', 'Ivic', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Frane', 'Baric', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Filip', 'Bilic', '1975-08-30', '1', 'developer', 1, 1),
(default, 'Karlo', 'Puljak', '1977-08-30', '1', 'developer', 1, 1),
(default, 'Tino', 'Tokic', '1977-08-30', '1', 'developer', 1, 1),
(default, 'Ivica', 'Pulic', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Frane', 'Petric', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Frane', 'Franic', '1975-08-30', '1', 'developer', 1, 1),
(default, 'Paul', 'Ramljak', '1977-08-30', '1', 'developer', 1, 1),
(default, 'Paulo', 'Penava', '1977-08-30', '1', 'developer', 1, 1),
(default, 'Tino', 'Sule', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Stipe', 'Baric', '1979-10-10', '1', 'developer', 3, 4),
(default, 'Milan', 'Sokic', '1975-08-30', '1', 'developer', 1, 1),
(default, 'Duje', 'Brkic', '1977-08-30', '1', 'developer', 1, 1),
(default, 'Antonio', 'Puljak', '1977-08-30', '1', 'developer', 1, 1);

INSERT INTO Projects(Id, Name) VALUES
(default, 'project1'),
(default, 'project2'),
(default, 'project3'),
(default, 'project4'),
(default, 'project5');

INSERT INTO ScientificWorks(Id, Name, NumberOfQuotes, ReleaseDate, UsedInProjectId) VALUES
(default, 'Logarithm function', 30, '2010-5-6', 1),
(default, 'Funkcije', 10, '2011-5-10', 1),
(default, 'The God Particle', 25, '2015-10-6', 2),
(default, 'Generalized Approach to Differentiability', 205, '1999-10-6', 4),
(default, 'The finite coarse shape ', 200, '2016-10-6', 1);

INSERT INTO ScientistScientificWork(ScientistId,ScientificWorkId ) VALUES
(1, 1),
(2, 1),
(1, 2),
(3, 2),
(1, 3),
(2, 3),
(3, 3),
(9, 4),
(10,4),
(9, 5),
(11,5);

INSERT INTO Accelerators(Id, Name) VALUES
(default, 'accelerator1'),
(default, 'accelerator2'),
(default, 'accelerator3'),
(default, 'accelerator4'),
(default, 'accelerator5'),
(default, 'accelerator6');

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
(6, 1);

-------SELECT QUERIES-------
--1-- 
--naziv i datum objave svakog znanstvenog rada zajedno s imenima znanstvenika koji su na njemu radili, 
--pri čemu imena znanstvenika moraju biti u jednoj ćeliji i u obliku Prezime, I.; npr. Puljak, I.; Godinović, N.; Bilušić, A.
SELECT sw.Name, sw.ReleaseDate, STRING_AGG(CONCAT(s.Surname, ', ', LEFT(s.Name, 1), '.'), '; ') AS Scientists FROM ScientificWorks sw 
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
c.Name AS Country, CONCAT(c.PPPCapita, '$') AS PPP_CapitaInUSD
FROM Scientists s
JOIN Countries c ON c.Id=s.CountryId

--3--
--svaku kombinaciju projekta i akceleratora, pri čemu nas zanimaju samo nazivi; 
--u slučaju da projekt nije vezan ni za jedan akcelerator, svejedno ga ispiši uz ime akceleratora ‘NEMA GA’.
SELECT p.Name AS Projects, 
COALESCE((SELECT STRING_AGG(a.Name, ' ') FROM Accelerators a 
		 JOIN AcceleratorProject ap ON a.Id=ap.AcceleratorId
		 JOIN Projects ps ON ap.ProjectId=ps.Id
		WHERE ps.Id=p.Id
		), 'None') AS Accelerators
FROM Projects p
ORDER BY p.Name

--4--
--sve projekte kojima je bar jedan od radova izašao između 2015. i 2017.
SELECT DISTINCT ON(p.Name) p.Name AS Projects FROM Projects p 
JOIN ScientificWorks sw ON sw.UsedInProjectId=p.Id
WHERE DATE_PART('year', sw.ReleaseDate)>2014 AND DATE_PART('year', sw.ReleaseDate)<2017

--5-- 
--u istoj tablici po zemlji broj radova i najpopularniji rad znanstvenika iste zemlje, 
--pri čemu je najpopularniji rad onaj koji ima najviše citata
SELECT c.Name, COUNT(DISTINCT  sw.Id) AS NumberOfScientificWorks,
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
SELECT a.Name, ROUND(AVG(sw.NumberOfQuotes), 2) AS AverageNumberOfQuotes FROM Accelerators a
JOIN AcceleratorProject ap ON ap.AcceleratorId=a.Id
JOIN Projects p ON p.Id=ap.ProjectId
JOIN ScientificWorks sw ON p.Id=sw.UsedInProjectId
GROUP BY a.Name
ORDER BY a.Name

--9--broj znanstvenika po struci, desetljeću rođenja i spolu; 
--u slučaju da je broj znanstvenika manji od 20, ne prikazuj kategoriju; 
--poredaj prikaz po desetljeću rođenja
SELECT s.Profession, s.Gender, EXTRACT(DECADE FROM s3.BirthDate) AS DecadeOfBirth, COUNT(s.Id) AS NumberOfScientists
FROM Scientists s
JOIN Scientists s3 ON s.Id=s3.Id AND s.Gender=s3.Gender
GROUP BY s.Profession, s.Gender, EXTRACT(DECADE FROM s3.BirthDate)
HAVING COUNT(s.Id)>20
ORDER BY EXTRACT(DECADE FROM s3.BirthDate)

--ako treba prikaz koji je gender rijecima
SELECT s.Profession, 
CASE WHEN s.Gender='0' THEN 'Not known'
WHEN s.Gender='1' THEN 'Male'
WHEN s.Gender='2' THEN 'Female'
WHEN s.Gender='9' THEN 'Not applicable'
END AS Gender,
EXTRACT(DECADE FROM s3.BirthDate) AS DecadeOfBirth, COUNT(s.Id) AS NumberOfScientists
FROM Scientists s
JOIN Scientists s3 ON s.Id=s3.Id AND s.Gender=s3.Gender
GROUP BY s.Profession, s.Gender, EXTRACT(DECADE FROM s3.BirthDate)
HAVING COUNT(s.Id)>20
ORDER BY EXTRACT(DECADE FROM s3.BirthDate)

--additional--try
--prikaži 10 najbogatijih znanstvenika, ako po svakom radu dobije brojCitatabrojZnanstvenikaPoRadu €
SELECT DISTINCT ON(s.Name, s.Surname) s.Name, s.Surname,
CONCAT(ROUND(SUM((SELECT (SQRT(swn.NumberOfQuotes)) FROM ScientificWorks swn
	  JOIN ScientistScientificWork sswn ON sswn.ScientificWorkId=swn.Id
	  JOIN Scientists ss ON sswn.ScientistId=ss.Id
	 WHERE swn.Id=sw.Id AND ss.Id=s.Id)/
(SELECT COUNT(sswn.ScientistId) FROM ScientistScientificWork sswn
 JOIN Scientists sss ON sss.Id=sswn.ScientistId
 WHERE sswn.ScientificWorkId=sw.Id AND sss.Id=s.Id))), '€') AS Income
FROM Scientists s
JOIN ScientistScientificWork ssw ON ssw.ScientistId=s.Id
JOIN ScientificWorks sw ON sw.Id=ssw.ScientificWorkId
GROUP BY  sw.Id, s.Id
ORDER BY s.Name, s.Surname, Income DESC
LIMIT 10