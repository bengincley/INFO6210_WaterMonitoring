-------------------------------------------------------------------------------
----------------------- Group 1 Project ---------------------------------------
-- Members: Arie Halpern, Ben Gincley, Melissa Heller, ------------------------
----------- Chenxuan He, Neeraj Sudhakar --------------------------------------
-------------------------------------------------------------------------------


create database ProjectTeam1;
go

use ProjectTeam1;
go

-------------------------------------------------------------------------------
---------------------------- Dimension Tables ---------------------------------
-------------------------------------------------------------------------------

-- Institution
create table Institution
(institution_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
institution_name VARCHAR(32) not null,
institution_state VARCHAR(32) not null,
institution_country VARCHAR(32) not null
);

-- Researcher
create table Researcher
(researcher_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
institution_ID INT not null REFERENCES dbo.Institution(institution_ID),
researcher_firstname VARCHAR(32) not null,
researcher_lastname VARCHAR(32) not null,
researcher_email VARCHAR(32),
researcher_phone VARCHAR(16)
);

-- Instrument
create table Instrument
(instrument_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
institution_ID INT not null REFERENCES dbo.Institution(institution_ID),
instrument_latitude DECIMAL(8,6),
instrument_longitude DECIMAL(9,6),
instrument_type VARCHAR(32),
instrument_manufacturer VARCHAR(32),
instrument_activation_date DATETIME
);

-- One or more to many waterbody
CREATE TABLE WaterbodyManagement
(waterbodymanagement_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 management_organization VARCHAR(32) NOT NULL,
 management_email VARCHAR(32) NOT NULL,
 management_phone VARCHAR(32) NOT NULL
 );

 -- Regulation
CREATE TABLE Regulation
(regulation_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
 phosphorus DECIMAL NOT NULL,
 radioactivity DECIMAL NOT NULL,
 algal_cell_count INT NOT NULL,
 microcystin_concentration DECIMAL NOT NULL
 );

 -- Water body
CREATE TABLE Waterbody
(waterbody_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 waterbodymanagement_ID INT FOREIGN KEY REFERENCES dbo.WaterbodyManagement(waterbodymanagement_ID),
 regulation_ID INT FOREIGN KEY REFERENCES dbo.Regulation(regulation_ID),
 waterbody_latitude DECIMAL(9,6) NOT NULL,
 waterbody_longitude DECIMAL(9,6) NOT NULL,
 waterbody_state VARCHAR(32) NOT NULL,
 waterbody_classification VARCHAR(32) NOT NULL
 );

-------------------------------------------------------------------------------
---------------------------- Join Tables --------------------------------------
-------------------------------------------------------------------------------

-- Many to Many Researcher-Instrument join table
create table ResearcherInstrument
(instrument_ID INT not null REFERENCES dbo.Instrument(instrument_ID),
researcher_ID INT not null REFERENCES dbo.Researcher(researcher_ID),
PRIMARY KEY(instrument_ID,researcher_ID)
);
 
-------------------------------------------------------------------------------
---------------------------- Fact Tables --------------------------------------
-------------------------------------------------------------------------------

 -- WaterDissolvedOxygen
create table WaterDissolvedOxygen
(WaterDissolvedOxygen_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
dissolved_oxygen_value DECIMAL,
dissolved_oxygen_units VARCHAR(8),
measurement_time DATETIME
);

-- AmbientTemperature
create table AmbientTemperature 
(AmbientTemperature_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
temperature_value DECIMAL,
temperature_units VARCHAR(1),
measurement_time DATETIME
);

-- WaterTotalPhosphorus
create table WaterTotalPhosphorus 
(WaterTotalPhosphorus_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
total_phosphorus_value DECIMAL,
total_phosphorus_units VARCHAR(8),
measurement_time DATETIME
);

-- AmbientWind
create table AmbientWind 
(AmbientWind_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
wind_speed_value DECIMAL,
wind_speed_units VARCHAR(8),
wind_direction VARCHAR(4),
measurement_time DATETIME
);

-- AmbientHumidity
create table AmbientHumidity 
(AmbientHumidity_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
humidity_value DECIMAL,
measurement_time DATETIME
);

-- WaterSalinity
create table WaterSalinity 
( WaterSalinity_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
salinity_value DECIMAL,
salinity_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterpH
create table WaterpH
(WaterpH_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
ph_value DECIMAL,
measurement_time DATETIME
);

-- WaterBiological
create table WaterBiological 
(WaterBiological_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
total_cell_count_value INT,
optical_density_value DECIMAL,
chlorophyll_a_value DECIMAL,
chlorophyll_a_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterTurbidity
create table WaterTurbidity 
(WaterTurbidity_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
water_turbidity_value DECIMAL,
water_turbidity_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterTemperature
create table WaterTemperature
(WaterTemperature_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
temperature_value DECIMAL,
temperature_units VARCHAR(1),
measurement_time DATETIME
);

-- WaterTotalNitrogen
create table WaterTotalNitrogen
(WaterTotalNitrogen_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
total_nitrogen_value DECIMAL,
total_nitrogen_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterTDS
create table WaterTDS
(WaterTDS_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
TDS_value DECIMAL,
TDS_units VARCHAR(8),
measurement_time DATETIME
);

-------------------------------------------------------------------------------
---------------------------------- Views --------------------------------------
-------------------------------------------------------------------------------

