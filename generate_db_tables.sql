create database ProjectTeam1;
GO

use ProjectTeam1;
GO

create table Institution
(institution_ID  INT not null IDENTITY,
institution_name VARCHAR(32) not null,
institution_state VARCHAR(32) not null,
institution_country VARCHAR(32) not null
);
GO

create table Researcher
(researcher_ID INT not null IDENTITY,
institution_ID INT REFERENCES dbo.Institution(institution_ID),
researcher_firstname VARCHAR(32) not null,
researcher_lastname VARCHAR(32) not null,
researcher_email VARCHAR(32),
researcher_phone VARCHAR(16)
);
GO