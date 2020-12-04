USE ProjectTeam1;
GO

-- Create master key
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = 'Th1s_i5_a_5ecUr3_PwD';
-- Create certificate
CREATE CERTIFICATE SecurityCertificate
WITH SUBJECT = 'Water Monitoring DB Security Certificate',
EXPIRY_DATE = '2021-12-31';
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

-- Close and drop symmetric key
CLOSE SYMMETRIC KEY PT1SymmetricKey;