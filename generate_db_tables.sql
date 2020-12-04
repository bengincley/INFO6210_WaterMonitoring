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
researcher_phone VARCHAR(16),
username VARCHAR(32) not null,
password_encrypted VARCHAR(256) not null
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
 dissolved_oxygen DECIMAL(10,10) NOT NULL,
 water_temperature DECIMAL(10,10) NOT NULL,
 bacteria DECIMAL(10,10) NOT NULL,
 solids DECIMAL(10,10) NOT NULL,
 color DECIMAL(10,10) NOT NULL,
 turbidity DECIMAL(10,10) NOT NULL,
 salinity DECIMAL(10,10) NOT NULL,
 nitrogen DECIMAL(10,10) NOT NULL,
 phosphorus DECIMAL(10,10) NOT NULL,
 radioactivity DECIMAL(10,10) NOT NULL,
 algal_cell_count INT NOT NULL,
 microcystin_concentration DECIMAL(10,10) NOT NULL
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
---------------------- Researcher Insert and Encryption -----------------------
-------------------------------------------------------------------------------

-- Create master key
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'Th1s_i5_a_5ecUr3_PwD';
-- Create certificate
CREATE CERTIFICATE SecurityCertificate
WITH SUBJECT = 'Project Team 1 Security Certificate',
EXPIRY_DATE = '2099-12-31';
-- Create symmetric key
CREATE SYMMETRIC KEY PT1SymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE SecurityCertificate;
-- Open symmetric key
OPEN SYMMETRIC KEY PT1SymmetricKey
DECRYPTION BY CERTIFICATE SecurityCertificate;

-- Insert encrypted data
INSERT INTO dbo.Researcher
(institution_ID,researcher_firstname,researcher_lastname,researcher_email,researcher_phone,username,password_encrypted )
VALUES
(1,'Benjamin','Gincley','gincley.b@northeastern.edu','(617) 555-0001','awesomepossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'awesomepassword'))),
(1,'Arie','Halpern','halpern.a@northeastern.edu','(617) 555-0002','okpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'okpassword'))),
(1,'Melissa','Scholem Heller','scholem.m@northeastern.edu','(617) 555-0003','goodpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'goodpassword'))),
(5,'Chenxuan','He','he.c@cleanlakes.com','(617) 555-000','alrightpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'alrightpassword'))),
(1,'Neeraj','Sudhakar','sudhakar.n@northeastern.edu','(617) 555-0005','verygoodpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'verygoodpassword'))),
(2,'Ameet','Pinto','a.pinto@bu.edu','(617) 555-0006','decentpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'decentpassword'))),
(2,'Chris','Anderson','c.anderson@bu.edu','(617) 555-0007','badpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'badpassword'))),
(3,'Adam','Smith','adam@epa.gov','(617) 555-0008','mediocrepossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'mediocrepassword'))),
(3,'Katherine','Huang','katie@epa.gov','(617) 555-0009','plainpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'plainpassword'))),
(4,'Michael','Williams','mike@mwra.com','(617) 555-0010','greatpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'greatpassword')));

-- Close symmetric key
CLOSE SYMMETRIC KEY PT1SymmetricKey;


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
---------------------------- Functions ----------------------------------------
-------------------------------------------------------------------------------

--Check if Salinity meets requirement
CREATE FUNCTION dbo.fn_MeetsCriteriaSalinity(@WaterbodyID INT, @value DECIMAL)
RETURNS INT
AS
	BEGIN
		DECLARE @output INT
		IF (SELECT salinity
			FROM Regulation r
			INNER JOIN Waterbody w on w.regulation_ID = r.regulation_ID
			and w.waterbody_ID = @WaterbodyID
			) >= @value
		SET @output = 1
		ELSE
		SET @output = 0
	RETURN @output
END;

--Check if Turbidity meets requirement
CREATE FUNCTION dbo.fn_MeetsCriteriaTurbidity(@WaterbodyID INT, @value DECIMAL)
RETURNS INT
AS
	BEGIN
		DECLARE @output INT
		IF (SELECT turbidity
			FROM Regulation r
			INNER JOIN Waterbody w on w.regulation_ID = r.regulation_ID
			and w.waterbody_ID = @WaterbodyID
			) >= @value
		SET @output = 1
		ELSE
		SET @output = 0
	RETURN @output
END

--Check if Nitrogen meets requirement
CREATE FUNCTION dbo.fn_MeetsCriteriaNitrogen(@WaterbodyID INT, @value DECIMAL)
RETURNS INT
AS
	BEGIN
		DECLARE @output INT
		IF (SELECT nitrogen
			FROM Regulation r
			INNER JOIN Waterbody w on w.regulation_ID = r.regulation_ID
			and w.waterbody_ID = @WaterbodyID
			) >= @value
		SET @output = 1
		ELSE
		SET @output = 0
	RETURN @output
END

--Check if Phosphorus meets requirement
CREATE FUNCTION dbo.fn_MeetsCriteriaPhosphorus(@WaterbodyID INT, @value DECIMAL)
RETURNS INT
AS
	BEGIN
		DECLARE @output INT
		IF (SELECT phosphorus
			FROM Regulation r
			INNER JOIN Waterbody w on w.regulation_ID = r.regulation_ID
			and w.waterbody_ID = @WaterbodyID
			) >= @value
		SET @output = 1
		ELSE
		SET @output = 0
	RETURN @output
END

--Check if Oxygen meets requirement
CREATE FUNCTION dbo.fn_MeetsCriteriaOxygen(@WaterbodyID INT, @value DECIMAL)
RETURNS INT
AS
	BEGIN
		DECLARE @output INT
		IF (SELECT dissolved_oxygen
			FROM Regulation r
			INNER JOIN Waterbody w on w.regulation_ID = r.regulation_ID
			and w.waterbody_ID = @WaterbodyID
			) >= @value
		SET @output = 1
		ELSE
		SET @output = 0
	RETURN @output
END


-------------------------------------------------------------------------------
---------------------------- Fact Tables --------------------------------------
-------------------------------------------------------------------------------

 -- WaterDissolvedOxygen
create table WaterDissolvedOxygen
(WaterDissolvedOxygen_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
dissolved_oxygen_value DECIMAL(10,10),
dissolved_oxygen_units VARCHAR(8),
measurement_time DATETIME
);

-- AmbientTemperature
create table AmbientTemperature 
(AmbientTemperature_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
temperature_value DECIMAL(10,10),
temperature_units VARCHAR(1),
measurement_time DATETIME
);

-- WaterTotalPhosphorus
create table WaterTotalPhosphorus 
(WaterTotalPhosphorus_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
total_phosphorus_value DECIMAL(10,10),
total_phosphorus_units VARCHAR(8),
measurement_time DATETIME
);

-- AmbientWind
create table AmbientWind 
(AmbientWind_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
wind_speed_value DECIMAL(10,10),
wind_speed_units VARCHAR(8),
wind_direction VARCHAR(4),
measurement_time DATETIME
);

-- AmbientHumidity
create table AmbientHumidity 
(AmbientHumidity_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
humidity_value DECIMAL(10,10),
measurement_time DATETIME
);

-- WaterSalinity
create table WaterSalinity 
( WaterSalinity_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
salinity_value DECIMAL(10,10),
salinity_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterpH
create table WaterpH
(WaterpH_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
ph_value DECIMAL(10,10),
measurement_time DATETIME
);

-- WaterBiological
create table WaterBiological 
(WaterBiological_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
total_cell_count_value INT,
optical_density_value DECIMAL(10,10),
chlorophyll_a_value DECIMAL(10,10),
chlorophyll_a_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterTurbidity
create table WaterTurbidity 
(WaterTurbidity_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
water_turbidity_value DECIMAL(10,10),
water_turbidity_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterTemperature
create table WaterTemperature
(WaterTemperature_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
temperature_value DECIMAL(10,10),
temperature_units VARCHAR(1),
measurement_time DATETIME
);

-- WaterTotalNitrogen
create table WaterTotalNitrogen
(WaterTotalNitrogen_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
total_nitrogen_value DECIMAL(10,10),
total_nitrogen_units VARCHAR(8),
measurement_time DATETIME
);

-- WaterTDS
create table WaterTDS
(WaterTDS_ID BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY,
instrument_ID INT not null FOREIGN KEY REFERENCES dbo.Instrument(instrument_ID),
waterbody_ID INT not null FOREIGN KEY REFERENCES dbo.Waterbody(waterbody_ID),
TDS_value DECIMAL(10,10),
TDS_units VARCHAR(8),
measurement_time DATETIME
);

-------------------------------------------------------------------------------
--------------------- Adding Computed Values to Columns -----------------------
-------------------------------------------------------------------------------

ALTER TABLE WaterSalinity
ADD MeetsCriteria AS (dbo.fn_MeetsCriteriaSalinity(waterbody_ID, salinity_value));

ALTER TABLE WaterTurbidity
ADD MeetsCriteria AS (dbo.fn_MeetsCriteriaTurbidity(waterbody_ID, water_turbidity_value));

ALTER TABLE WaterTotalPhosphorus
ADD MeetsCriteria AS (dbo.fn_MeetsCriteriaPhosphorus(waterbody_ID, total_phosphorus_value));

ALTER TABLE WaterTotalNitrogen
ADD MeetsCriteria AS (dbo.fn_MeetsCriteriaNitrogen(waterbody_ID, total_nitrogen_value));

ALTER TABLE WaterDissolvedOxygen
ADD MeetsCriteria AS (dbo.fn_MeetsCriteriaOxygen(waterbody_ID, dissolved_oxygen_value));

-------------------------------------------------------------------------------
---------------------------------- Views --------------------------------------
-------------------------------------------------------------------------------
