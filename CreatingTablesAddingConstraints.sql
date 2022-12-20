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