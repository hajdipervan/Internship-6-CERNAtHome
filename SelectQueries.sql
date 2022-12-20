--1-- 
--naziv i datum objave svakog znanstvenog rada zajedno s imenima znanstvenika koji su na njemu radili, 
--pri čemu imena znanstvenika moraju biti u jednoj ćeliji i u obliku Prezime, I.; npr. Puljak, I.; Godinović, N.; Bilušić, A.
SELECT sw.Name, sw.ReleaseDate, STRING_AGG(CONCAT(s.Surname, ', ', LEFT(s.Name, 1), '.'), '; ') FROM ScientificWorks sw 
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

--5-- RADI
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

--ako treba prikaz di je gender rijecima
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