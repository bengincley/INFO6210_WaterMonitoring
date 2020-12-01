create database ProjectTeam1;
GO

use ProjectTeam1;
GO

create table Institution
(institution_ID  INT not null primary key,
institution_name VARCHAR(32) not null,
institution_state VARCHAR(32) not null,
institution_country VARCHAR(32) not null
);
GO

create table Researcher
(researcher_ID INT not null primary key,
institution_ID INT not null REFERENCES dbo.Institution(institution_ID),
researcher_firstname VARCHAR(32) not null,
researcher_lastname VARCHAR(32) not null,
researcher_email VARCHAR(32),
researcher_phone VARCHAR(16)
);
GO

create table Instrument
(instrument_ID INT not null primary key,
institution_ID INT not null REFERENCES dbo.Institution(institution_ID),
instrument_latitude DECIMAL(8,6),
instrument_longitude DECIMAL(9,6),
instrument_type VARCHAR(32),
instrument_manufacturer VARCHAR(32),
instrument_activation_date DATE
);
GO

create table ResearcherInstrument
(instrument_ID INT not null REFERENCES dbo.Instrument(instrument_ID),
researcher_ID INT not null REFERENCES dbo.Researcher(researcher_ID),
primary key(instrument_ID,researcher_ID)
);
GO

