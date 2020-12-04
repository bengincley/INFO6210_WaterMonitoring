USE ProjectTeam1 ;
GO
--One or more to many waterbody
CREATE TABLE WaterbodyManagement
(waterbodymanagement_ID INT NOT NULL PRIMARY KEY,
 management_organization VARCHAR(32) NOT NULL,
 management_email VARCHAR(32) NOT NULL,
 management_phone VARCHAR(32) NOT NULL);

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
 microcystin_concentration DECIMAL NOT NULL);


CREATE TABLE Waterbody
(waterbody_ID INT NOT NULL PRIMARY KEY,
 waterbodymanagement_ID INT FOREIGN KEY REFERENCES dbo.WaterbodyManagement(waterbodymanagement_ID),
 regulation_ID INT FOREIGN KEY REFERENCES dbo.Regulation(regulation_ID),
 waterbody_latitude DECIMAL(9,6) NOT NULL,
 waterbody_longitude DECIMAL(9,6) NOT NULL,
 waterbody_state VARCHAR(32) NOT NULL,
 waterbody_classification VARCHAR(32) NOT NULL);








