create database ProjectTeam1;
go

use ProjectTeam1;
go

-- Institution
create table Institution
(institution_ID  INT not null PRIMARY KEY,
institution_name VARCHAR(32) not null,
institution_state VARCHAR(32) not null,
institution_country VARCHAR(32) not null
);

-- Researcher
create table Researcher
(researcher_ID INT not null PRIMARY KEY,
institution_ID INT not null REFERENCES dbo.Institution(institution_ID),
researcher_firstname VARCHAR(32) not null,
researcher_lastname VARCHAR(32) not null,
researcher_email VARCHAR(32),
researcher_phone VARCHAR(16)
);

-- Instrument
create table Instrument
(instrument_ID INT not null PRIMARY KEY,
institution_ID INT not null REFERENCES dbo.Institution(institution_ID),
instrument_latitude DECIMAL(8,6),
instrument_longitude DECIMAL(9,6),
instrument_type VARCHAR(32),
instrument_manufacturer VARCHAR(32),
instrument_activation_date DATE
);

-- Many to Many Researcher-Instrument join table
create table ResearcherInstrument
(instrument_ID INT not null REFERENCES dbo.Instrument(instrument_ID),
researcher_ID INT not null REFERENCES dbo.Researcher(researcher_ID),
PRIMARY KEY(instrument_ID,researcher_ID)
);

-- One or more to many waterbody
CREATE TABLE WaterbodyManagement
(waterbodymanagement_ID INT NOT NULL PRIMARY KEY,
 management_organization VARCHAR(32) NOT NULL,
 management_email VARCHAR(32) NOT NULL,
 management_phone VARCHAR(32) NOT NULL
 );

 -- Regulation
CREATE TABLE Regulation
(regulation_ID INT NOT NULL PRIMARY KEY,
 regulation_jurisdiction VARCHAR(32) NOT NULL,
 regulation_standard VARCHAR(32) NOT NULL,
 dissolved_oxygen DECIMAL NOT NULL,
 water_temperature DECIMAL NOT NULL,
 bacteria DECIMAL NOT NULL,
 solids DECIMAL NOT NULL,
 color DECIMAL NOT NULL,
 turbidity DECIMAL NOT NULL,
 salinity DECIMAL NOT NULL,
 nitrogen DECIMAL NOT NULL,
 phosphorous DECIMAL NOT NULL,
 radioactivity DECIMAL NOT NULL,
 algal_cell_count INT NOT NULL,
 microcystin_concentration DECIMAL NOT NULL
 );

 -- Water body
CREATE TABLE Waterbody
(waterbody_ID INT NOT NULL PRIMARY KEY,
 waterbodymanagement_ID INT FOREIGN KEY REFERENCES dbo.WaterbodyManagement(waterbodymanagement_ID),
 regulation_ID INT FOREIGN KEY REFERENCES dbo.Regulation(regulation_ID),
 waterbody_latitude DECIMAL(9,6) NOT NULL,
 waterbody_longitude DECIMAL(9,6) NOT NULL,
 waterbody_state VARCHAR(32) NOT NULL,
 waterbody_classification VARCHAR(32) NOT NULL
 );