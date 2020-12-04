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
(username,password_encrypted )
VALUES
('awesomepossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'awesomepassword'))),
('okpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'okpassword'))),
('goodpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'goodpassword'))),
('alrightpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'alrightpassword'))),
('verygoodpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'verygoodpassword'))),
('decentpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'decentpassword'))),
('badpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'badpassword'))),
('mediocrepossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'mediocrepassword'))),
('plainpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'plainpassword'))),
('greatpossum' , EncryptByKey(Key_GUID(N'PT1SymmetricKey'), convert(varbinary, 'greatpassword')));

-- Close and drop symmetric key
CLOSE SYMMETRIC KEY PT1SymmetricKey;
DROP SYMMETRIC KEY PT1SymmetricKey;
-- Drop the certificate
DROP CERTIFICATE SecurityCertificate;
--Drop the master key
DROP MASTER KEY;