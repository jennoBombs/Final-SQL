--1. Create a new data base yournamegym
CREATE DATABASE JRProgram
ON PRIMARY
(
 NAME = 'JRProgram_dat',
 FILENAME = 'C:\Program Files\Microsoft SQL Server\Mssql13.mssqlserver\mssql\data\JRProgram.mdf',
 SIZE = 10,
 MAXSIZE = 50,
 FILEGROWTH = 15%
)
LOG ON
(
 NAME = 'JRProgram_log',
 FILENAME = 'C:\Program Files\Microsoft SQL Server\Mssql13.mssqlserver\mssql\data\JRProgram.ldf',
 SIZE = 10,
 MAXSIZE = 50,
 FILEGROWTH = 15%
)

--2 Create the member table with the name of yournameMember
USE JRProgram
IF OBJECT_ID('JRGym') IS NOT NULL
	DROP TABLE JRGym
GO

CREATE TABLE JRGym
(
ProgramID        INTEGER     NOT NULL PRIMARY KEY,
ProgramType		 VARCHAR(50) NOT NULL,
MonthlyFee       MONEY       NOT NULL,
PhysicalRequired VARCHAR(3)  NOT NULL
)

--3 Create the Member
USE JRProgram
IF OBJECT_ID('JRMember') IS NOT NULL
	DROP TABLE JRMember
GO

CREATE TABLE JRMember
(
MemberID         INTEGER     NOT NULL PRIMARY KEY,
ProgramID        INTEGER     NOT NULL FOREIGN KEY REFERENCES JRGym,
FirstName        VARCHAR(20) NOT NULL,
LastName	     VARCHAR(20) NOT NULL,
Street			 VARCHAR(50) NOT NULL,
City			 VARCHAR(20) NOT NULL,
State			 VARCHAR(2)  NOT NULL,
Zip				 INTEGER	 NOT NULL,
Phone			 VARCHAR(12) NOT NULL,
JoinDate		 DATE		 NOT NULL,
ExpirationDate	 DATE		 NULL,
MembershipStatus VARCHAR(20) NOT NULL
)

--4 Add the following constraint using alter - monthly fee should never be < 15.00
ALTER TABLE JRGym
ADD CHECK (MonthlyFee >= 15.00)

--5 Write the code to insert the first five records into the JRProgramtable
INSERT INTO JRGym
VALUES (201,'Junior Full (ages 13-17)',$35.00,'Yes')
INSERT INTO JRGym
VALUES(202,'Junior Limited (ages 13-17)',$25.00,'Yes')
INSERT INTO JRGym
VALUES(203,'Young Adult Full (ages 18-25)',$45.00,'No')
INSERT INTO JRGym
VALUES(204,'Young Adult Limited (ages 18-25)',$30.00,'No')
INSERT INTO JRGym
VALUES(205,'Young Adult Special (ages 18-25)',$20.00,'No')

--6 Write a stored procedure that validates the foreign key and inserts records into the member table
-- name the stored procedure JRInsertMembers
IF OBJECT_ID('JRInsertMembers') IS NOT NULL
	DROP PROC JRInsertMembers
GO

CREATE PROC JRInsertMembers
@MemberID integer,
@ProgramID integer,
@FirstName varchar(20),
@LastName varchar(20),
@Street varchar(50),
@City varchar(20),
@State varchar(2),
@Zip integer,
@Phone varchar(12),
@JoinDate date,
@ExpirationDate date,
@MembershipStatus varchar(20)
AS
IF EXISTS (SELECT * FROM JRGym WHERE @ProgramID = ProgramID)
	INSERT INTO JRMember
	VALUES(@MemberID,@ProgramID,@FirstName,@LastName, @Street,@City,@State,@Zip, @Phone,
		@JoinDate, @ExpirationDate, @MembershipStatus);
	ELSE
		THROW 50001, 'ProgramID does not exist', 1;

--7 Test with invalid ProgramID
BEGIN TRY
	EXEC JRInsertMembers
@MemberID = 1103,
@ProgramID = 200,
@FirstName ='Spencer',
@LastName = 'Buckmiller',
@Street = '29 Prospect Street',
@City = 'Ashland',
@State = 'VA',
@Zip = 23005,
@Phone = 804550305,
@JoinDate = '01/16/2013',
@ExpirationDate = '01/16/2014',
@MembershipStatus = 'Active';
END TRY
BEGIN CATCH
	PRINT 'ERROR : ' + CONVERT(varchar, error_message());
END CATCH

--8
BEGIN TRY
	EXEC JRInsertMembers
@MemberID = 1103,
@ProgramID = 201,
@FirstName ='Spencer',
@LastName = 'Buckmiller',
@Street = '29 Prospect Street',
@City = 'Ashland',
@State = 'VA',
@Zip = 23005,
@Phone = 804550305,
@JoinDate = '01/16/2013',
@ExpirationDate = '01/16/2014',
@MembershipStatus = 'Active';
END TRY
BEGIN CATCH
	PRINT 'ERROR : ' + CONVERT(varchar, error_message());
END CATCH

BEGIN TRY
	EXEC JRInsertMembers
@MemberID = 1105,
@ProgramID = 204,
@FirstName ='Barry',
@LastName = 'Hassan',
@Street = '9 Harrington Avenue',
@City = 'Richmond',
@State = 'VA',
@Zip = 23220,
@Phone = 8042366717,
@JoinDate = '03/02/2013',
@ExpirationDate = '03/02/2015',
@MembershipStatus = 'Active';
END TRY
BEGIN CATCH
	PRINT 'ERROR : ' + CONVERT(varchar, error_message());
END CATCH

BEGIN TRY
	EXEC JRInsertMembers
@MemberID = 1110,
@ProgramID = 201,
@FirstName ='Ashish',
@LastName = 'Mittal',
@Street = '103 Hubbard Way',
@City = 'Glen Allen',
@State = 'VA',
@Zip = 23058,
@Phone = 8045537986,
@JoinDate = '04/03/2013',
@ExpirationDate = '04/03/2014',
@MembershipStatus = 'On Hold';
END TRY
BEGIN CATCH
	PRINT 'ERROR : ' + CONVERT(varchar, error_message());
END CATCH

BEGIN TRY
	EXEC JRInsertMembers
@MemberID = 1111,
@ProgramID = 203,
@FirstName ='Liz',
@LastName = 'Sorrento',
@Street = '134 Lincoln Road',
@City = 'Chester',
@State = 'VA',
@Zip = 23831,
@Phone = 8047511270,
@JoinDate = '02/10/2013',
@ExpirationDate = '08/20/2013',
@MembershipStatus = 'Active';
END TRY
BEGIN CATCH
	PRINT 'ERROR : ' + CONVERT(varchar, error_message());
END CATCH

BEGIN TRY
	EXEC JRInsertMembers
@MemberID = 1115,
@ProgramID = 203,
@FirstName ='Michelle',
@LastName = 'Kim',
@Street = '1290 Brook Mill Road',
@City = 'Bon Air',
@State = 'VA',
@Zip = 23235,
@Phone = 8043230291,
@JoinDate = '05/17/2013',
@ExpirationDate = '05/17/2015',
@MembershipStatus = 'Active';
END TRY
BEGIN CATCH
	PRINT 'ERROR : ' + CONVERT(varchar, error_message());
END CATCH

SELECT * FROM JRMember

--9 Write a stored procedure that returns the number of members in the members table
IF OBJECT_ID('JRMemberCount') IS NOT NULL
	DROP PROC JRMemberCount
GO

CREATE PROC JRMemberCount
AS
SELECT COUNT(MemberID) AS 'Member Count' FROM JRMember 

EXEC JRMemberCount;

--10 Update member 1105 to Jennifer Reisinger
UPDATE JRMember
SET FirstName = 'Jennifer', LastName = 'Reisinger'
WHERE MemberID = 1105

SELECT * FROM JRMember

--11 Create a trigger named JRMemberDelete that will not allow the deletion
--of more than one record from the JRMember table
CREATE TRIGGER JRMemberDelete ON JRMember
FOR DELETE
AS
IF(SELECT COUNT(*) FROM DELETED) > 1
	BEGIN;
		THROW 50001, 'Cannot delete more than 1 record',1
		ROLLBACK TRANSACTION
		END;
ELSE
	SELECT MemberID, ProgramID, FirstName, LastName, Street, City, State, 
		Zip, Phone, JoinDate, ExpirationDate, MembershipStatus, 'Deleted' AS STATUS
	FROM deleted

--12 Test the deletion trigger
BEGIN TRY
	DELETE FROM JRMember
END TRY
BEGIN CATCH
	PRINT 'ERROR: ' + CONVERT(VARCHAR, ERROR_MESSAGE())
END CATCH

--13 Create a view named JRAgg that displays min, max, and avg monthly fee
CREATE VIEW JRAgg
AS
SELECT MIN(MonthlyFee) AS 'Min Monthly Fee', MAX(MonthlyFee) AS 'Max Monthly Fee', AVG(MonthlyFee) AS 'AVG Monthly Fee'
FROM JRGym