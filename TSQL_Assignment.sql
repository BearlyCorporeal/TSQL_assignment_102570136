IF OBJECT_ID('Sale0136') IS NOT NULL DROP TABLE SALE0136;
IF OBJECT_ID('Product0136') IS NOT NULL DROP TABLE PRODUCT0136;
IF OBJECT_ID('Customer0136') IS NOT NULL DROP TABLE CUSTOMER0136;
IF OBJECT_ID('Location0136') IS NOT NULL DROP TABLE LOCATION0136;
IF OBJECT_ID('ADD_CUSTOMER0136') IS NOT NULL DROP PROCEDURE ADD_CUSTOMER0136;
IF OBJECT_ID('DELETE_ALL_CUSTOMERS0136') IS NOT NULL DROP PROCEDURE DELETE_ALL_CUSTOMERS0136;
IF OBJECT_ID('ADD_PRODUCT0136') IS NOT NULL DROP PROCEDURE ADD_PRODUCT0136;
IF OBJECT_ID('DELETE_ALL_PRODUCTS0136') IS NOT NULL DROP PROCEDURE DELETE_ALL_PRODUCTS0136;
IF OBJECT_ID('GET_CUSTOMER_STRING0136') IS NOT NULL DROP PROCEDURE GET_CUSTOMER_STRING0136;
IF OBJECT_ID('UPD_CUST_SALESYTD0136') IS NOT NULL DROP PROCEDURE UPD_CUST_SALESYTD0136;
IF OBJECT_ID('GET_PROD_STRING0136') IS NOT NULL DROP PROCEDURE GET_PROD_STRING0136;
IF OBJECT_ID('UPD_PROD_SALESYTD0136') IS NOT NULL DROP PROCEDURE UPD_PROD_SALESYTD0136;
IF OBJECT_ID('UPD_CUSTOMER_STATUS0136') IS NOT NULL DROP PROCEDURE UPD_CUSTOMER_STATUS0136;
IF OBJECT_ID('ADD_SIMPLE_SALE0136') IS NOT NULL DROP PROCEDURE ADD_SIMPLE_SALE0136;
IF OBJECT_ID('SUM_CUSTOMER_SALESYTD0136') IS NOT NULL DROP PROCEDURE SUM_CUSTOMER_SALESYTD0136;
IF OBJECT_ID('SUM_PRODUCT_SALESYTD0136') IS NOT NULL DROP PROCEDURE SUM_PRODUCT_SALESYTD0136;
IF OBJECT_ID('GET_ALL_CUSTOMERS0136') IS NOT NULL DROP PROCEDURE GET_ALL_CUSTOMERS0136;
IF OBJECT_ID('GET_ALL_PRODUCTS0136') IS NOT NULL DROP PROCEDURE GET_ALL_PRODUCTS0136;
IF OBJECT_ID('ADD_LOCATION0136') IS NOT NULL DROP PROCEDURE ADD_LOCATION0136;
IF OBJECT_ID('ADD_COMPLEX_SALE0136') IS NOT NULL DROP PROCEDURE ADD_COMPLEX_SALE0136;
IF OBJECT_ID('GET_ALLSALES0136') IS NOT NULL DROP PROCEDURE GET_ALLSALES0136;
IF OBJECT_ID('COUNT_PRODUCT_SALES0136') IS NOT NULL DROP PROCEDURE COUNT_PRODUCT_SALES0136;
IF OBJECT_ID('DELETE_SALE0136') IS NOT NULL DROP PROCEDURE DELETE_SALE0136;
IF OBJECT_ID('DELETE_ALL_SALES0136') IS NOT NULL DROP PROCEDURE DELETE_ALL_SALES0136;
IF OBJECT_ID('DELETE_CUSTOMER0136') IS NOT NULL DROP PROCEDURE DELETE_CUSTOMER0136;
IF OBJECT_ID('DELETE_PRODUCT0136') IS NOT NULL DROP PROCEDURE DELETE_PRODUCT0136;


GO
CREATE TABLE CUSTOMER0136 (
CUSTID INT
, CUSTNAME  NVARCHAR(100)
, SALES_YTD INT
, STATUS    NVARCHAR(7)
, PRIMARY KEY     (CUSTID) );

CREATE TABLE PRODUCT0136 (
PRODID INT
, PRODNAME  NVARCHAR(50)
, SELLING_PRICE   MONEY
, SALES_YTD MONEY
, PRIMARY KEY     (PRODID));

CREATE TABLE SALE0136 (
SALEID INT
, CUSTID    INT
, PRODID    INT
, QTY INT
, PRICE     MONEY
, SALEDATE  DATE
, PRIMARY KEY     (SALEID)
, FOREIGN KEY     (CUSTID) REFERENCES CUSTOMER0136
, FOREIGN KEY     (PRODID) REFERENCES PRODUCT0136);

CREATE TABLE LOCATION0136 (
LOCID     NVARCHAR(5)
, MINQTY    INTEGER
, MAXQTY    INTEGER
, PRIMARY KEY     (LOCID)
, CONSTRAINT CHECK_LOCID_LENGTH CHECK (LEN(LOCID) = 5)
, CONSTRAINT CHECK_MINQTY_RANGE CHECK (MINQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_RANGE CHECK (MAXQTY BETWEEN 0 AND 999)
, CONSTRAINT CHECK_MAXQTY_GREATER_MIXQTY CHECK (MAXQTY >= MINQTY));
IF OBJECT_ID('SALE_SEQ0136') IS NOT NULL DROP SEQUENCE SALE_SEQ0136;
CREATE SEQUENCE SALE_SEQ0136 AS INT;

GO

create PROCEDURE ADD_CUSTOMER0136 @pcustid INT,@pcustname nvarchar(100) as 
BEGIN TRY
BEGIN TRANSACTION ADD_CUSTOMER
IF @pcustid < 1 OR @pcustid > 499 THROW 50020, 'Customer ID out of range', 1
INSERT INTO CUSTOMER0136(CUSTID,CUSTNAME,SALES_YTD,STATUS) VALUES (@pcustid,@pcustname,0,'OK');
COMMIT TRANSACTION ADD_CUSTOMER
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION ADD_CUSTOMER
if ERROR_NUMBER() = 2627
THROW 50010, 'Duplicate customer ID', 1;
ELSE IF ERROR_NUMBER() = 50020
THROW 50020,'Customer ID out of range',1;
ELSE
BEGIN
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END;
END CATCH;

GO

create PROCEDURE DELETE_ALL_CUSTOMERS0136 as 
BEGIN TRY
BEGIN TRANSACTION DELETE_ALL_CUSTOMERS
DECLARE @NumOfRows Int; 
SELECT @NumOfRows = count(*) FROM CUSTOMER0136; 
DELETE FROM CUSTOMER0136 ;
SELECT CONCAT('number of rows deleted:',@NumOfRows);
COMMIT TRANSACTION DELETE_ALL_CUSTOMERS
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION DELETE_ALL_CUSTOMERS
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE ADD_PRODUCT0136 @pprodid Int,@pprodname nvarchar,@pprice money as 
BEGIN TRY
BEGIN TRANSACTION ADD_PRODUCT
IF @pprodid < 1000 OR @pprodid > 2500 THROW 50040, 'Product ID out of range', 1
IF @pprice < 0 OR @pprice > 999.99 THROW 50050, 'Price out of range', 1
INSERT INTO PRODUCT0136(PRODID,PRODNAME,SELLING_PRICE,SALES_YTD) VALUES (@pprodid,@pprodname,@pprice,0);
COMMIT TRANSACTION ADD_PRODUCT
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION ADD_PRODUCT
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 2627
THROW 50030, 'Duplicate product ID', 1 
ELSE IF ERROR_NUMBER() = 50040
THROW 50040, 'Product ID out of range', 1;
ELSE IF ERROR_NUMBER() = 50050
THROW 50050, 'Price out of range', 1
ELSE
THROW 50000, @ERRORMESSAGE, 1
END CATCH;
;

GO

create PROCEDURE DELETE_ALL_PRODUCTS0136 as 
BEGIN TRY
BEGIN TRANSACTION DELETE_ALL_PRODUCTS
DECLARE @NumOfRows Int; 
SELECT @NumOfRows = count(*) FROM PRODUCT0136;
DELETE FROM PRODUCT0136;
SELECT CONCAT('rows deleted:',@NumOfRows);
COMMIT TRANSACTION DELETE_ALL_PRODUCTS
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION DELETE_ALL_PRODUCTS
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE GET_CUSTOMER_STRING0136 @pcustid Int as 
BEGIN TRY
BEGIN TRANSACTION GET_CUSTOMER_STRING 
DECLARE @ok int;
IF (SELECT CUSTID FROM CUSTOMER0136 WHERE CUSTID = @pcustid) = @Pcustid SET @ok =1;
ELSE
THROW 50060, 'Customer ID not found', 1
DECLARE @NameOfCust nvarchar(100);
SET @NameOfCust = (SELECT CUSTNAME FROM CUSTOMER0136 WHERE CUSTID = @pcustid);
DECLARE @SalesOfCust INT;
SET @SalesOfCust = (SELECT SALES_YTD FROM CUSTOMER0136 WHERE CUSTID = @pcustid);
DECLARE @StatusOfCust NVARCHAR(7);
SET @StatusOfCust = (SELECT STATUS FROM CUSTOMER0136 WHERE CUSTID = @pcustid);
if @ok =1 SELECT CONCAT('custid:', @pcustid , ' name:' , @NameOfCust , ' status:' , @StatusOfCust ,  ' sales_ytd:' , @SalesOfCust , ';');
COMMIT TRANSACTION GET_CUSTOMER_STRING
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION GET_CUSTOMER_STRING
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50060
THROW 50060, 'Customer ID not found', 1;
ELSE
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE UPD_CUST_SALESYTD0136 @pcustid Int,@pamt Int as 
BEGIN TRY
BEGIN TRANSACTION UPD_CUST_SALESYTD
DECLARE @ok int;
IF (SELECT CUSTID FROM CUSTOMER0136 WHERE CUSTID = @pcustid) = @Pcustid SET @ok =1;
ELSE
THROW 50070, 'Customer ID not found', 1;
IF @pamt < -999.99 OR @pamt > 999.99 THROW 50080, 'Amount out of range', 1;
IF @ok =1 UPDATE CUSTOMER0136 set SALES_YTD = @pamt WHERE @pcustid = CUSTID;
COMMIT TRANSACTION UPD_CUST_SALESYTD
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION UPD_CUST_SALESYTD
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50080
THROW 50080, 'Amount out of range', 1;
ELSE IF ERROR_NUMBER() = 50070
THROW 50070, 'Customer ID not found', 1;
ELSE
THROW 50000, @ERRORMESSAGE, 1;
END CATCH; 

GO

create PROCEDURE GET_PROD_STRING0136 @pprodid Int as 
BEGIN TRY
BEGIN TRANSACTION GET_PRODUCT_STRING
DECLARE @ok int;
IF (SELECT PRODID FROM PRODUCT0136 WHERE PRODID = @pprodid) = @pprodid SET @ok =1;
ELSE
THROW 50090, 'Product ID not found', 1; 
DECLARE @Price MONEY;
SET @Price = (SELECT SELLING_PRICE FROM PRODUCT0136 WHERE PRODID = @pprodid)
DECLARE @salesytd MONEY;
SET @salesytd = (SELECT SALES_YTD FROM PRODUCT0136 WHERE PRODID = @pprodid)
DECLARE @Name NVARCHAR;
SET @Name = (SELECT PRODNAME FROM PRODUCT0136 WHERE PRODID = @pprodid)
if @ok = 1 SELECT CONCAT('ID:',@pprodid,'Name:' , @Name , ' Price:' , @Price , ' salesytd:' , @salesytd)
COMMIT TRANSACTION GET_PRODUCT_STRING
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION GET_PRODUCT_STRING
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50090
THROW 50090, 'Product ID not found', 1 
ELSE
THROW 50000, @ERRORMESSAGE, 1
END CATCH;;

GO

create PROCEDURE  UPD_PROD_SALESYTD0136 @pprodid Int,@pamt Int as 
BEGIN TRY
BEGIN TRANSACTION UPD_PROD_SALESYTD
DECLARE @ok int;
IF (SELECT PRODID FROM PRODUCT0136 WHERE PRODID = @pprodid) = @pprodid SET @ok =1;
ELSE
THROW 50100, 'Product ID not found', 1;
IF @pamt < -999.99 OR @pamt > 999.99 THROW 50110, 'Amount out of range', 1
IF @ok =1 UPDATE PRODUCT0136 set SALES_YTD = @pamt WHERE @pprodid = PRODID
COMMIT TRANSACTION UPD_PROD_SALESYTD
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION UPD_PROD_SALESYTD
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50100
THROW 50100, 'Product ID not found', 1;
ELSE IF ERROR_NUMBER() = 50110
THROW 50110, 'Amount out of range', 1
ELSE
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE UPD_CUSTOMER_STATUS0136 @pcustid Int,@pstatus Nvarchar(8) as 
BEGIN TRY
BEGIN TRANSACTION UPD_CUSTOMER_STATUS
DECLARE @ok int;
DECLARE @ok2 int;
DECLARE @ok3 int;
DECLARE @validstatus1 nvarchar(8);
SET @validstatus1 = 'OK';
DECLARE @validstatus2 nvarchar(8);
SET @validstatus2 = 'SUSPEND'

IF @pstatus = @validstatus1 OR @pstatus = @validstatus2 SET @OK2 =1
ELSE 
THROW 50130, 'Invalid Status value',1
IF (SELECT CUSTID FROM CUSTOMER0136 WHERE CUSTID = @pcustid) = @Pcustid SET @ok =1;
ELSE 
THROW 50120, 'Customer ID not found', 1;
if @ok =1 AND @ok2 =1 UPDATE CUSTOMER0136 set STATUS = @pstatus WHERE CUSTID = @pcustid;
COMMIT TRANSACTION UPD_CUSTOMER_STATUS
END TRY
Begin CATCH
ROLLBACK TRANSACTION UPD_CUSTOMER_STATUS
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50120
THROW 50120, 'Customer ID not found', 1;
ELSE IF ERROR_NUMBER() = 50130 
THROW 50130, 'Invalid Status value',1
ELSE
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE ADD_SIMPLE_SALE0136 @pcustid Int, @pprodid Int , @pqty Int as 
BEGIN TRY
BEGIN TRANSACTION ADD_SIMPLE_SALE
IF @pqty < 1 OR @pqty > 999 THROW 50140, 'Sale Quantity outside valid range',1;
DECLARE @pprice MONEY;
set @pprice =(select SELLING_PRICE FROM PRODUCT0136 WHERE PRODID = @pprodid);
declare @amount MONEY;
set @amount = @pqty * @pprice
DECLARE @StatusOfCust NVARCHAR(7);
SET @StatusOfCust = (SELECT STATUS FROM CUSTOMER0136 WHERE CUSTID = @pcustid);
declare @ok int;
IF @StatusOfCust = 'OK' set @ok =1;
ELSE
THROW 50150, 'Customer status is not OK', 1;
DECLARE @ok2 int;
IF (SELECT CUSTID FROM CUSTOMER0136 WHERE CUSTID = @pcustid) = @Pcustid SET @ok2 =1;
ELSE
THROW 50160, 'Customer ID not found', 1;
DECLARE @ok3 int;
IF (SELECT PRODID FROM PRODUCT0136 WHERE PRODID = @pprodid) = @pprodid SET @ok3 =1;
ELSE
THROW 50170, 'Product ID not found', 1; 
DECLARE @ok4 int;
if @ok =1 AND @ok2 =1 AND @ok3 =1 EXEC UPD_PROD_SALESYTD0136 @pprodid,@amount; 
if @ok =1 AND @ok2 =1 AND @ok3 =1 EXEC UPD_CUST_SALESYTD0136 @pcustid,@amount; 
if @ok =1 AND @ok2 =1 AND @ok3 =1 INSERT INTO SALE0136(SALEID,CUSTID,PRODID,QTY,PRICE) VALUES(NEXT VALUE FOR SALE_SEQ0136,@pcustid,@pprodid,@pqty,@pprice)
COMMIT TRANSACTION ADD_SIMPLE_SALE
END TRY
Begin CATCH
ROLLBACK TRANSACTION ADD_SIMPLE_SALE
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50150
THROW 50150, 'Customer status is not OK', 1;
ELSE IF ERROR_NUMBER() =50160
THROW 50160, 'Customer ID not found', 1;
ELSE IF ERROR_NUMBER() = 50170
THROW 50170, 'Product ID not found', 1; 
ELSE IF ERROR_NUMBER() = 50140
THROW 50140, 'Sale Quantity outside valid range',1
ELSE
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

CREATE PROCEDURE SUM_CUSTOMER_SALESYTD0136 AS
BEGIN TRY
BEGIN TRANSACTION SUM_CUSTOMER_SALESYTD
DECLARE @SUM INT
SET @SUM = (Select SUM(SALES_YTD) FROM CUSTOMER0136)
SELECT CONCAT('sum of sales_ytd: ',@SUM)
COMMIT TRANSACTION SUM_CUSTOMER_SALESYTD
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION SUM_CUSTOMER_SALESYTD
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

CREATE PROCEDURE SUM_PRODUCT_SALESYTD0136 AS
BEGIN TRY
BEGIN TRANSACTION SUM_CUSTOMER_SALESYTD
DECLARE @SUM INT
SET @SUM = (Select SUM(SALES_YTD) FROM PRODUCT0136)
SELECT CONCAT('sum of sales_ytd: ',@SUM)
COMMIT TRANSACTION SUM_CUSTOMER_SALESYTD
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION SUM_CUSTOMER_SALESYTD
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

create PROCEDURE GET_ALL_CUSTOMERS0136 @POUTCUR CURSOR VARYING OUTPUT AS   
BEGIN TRY
BEGIN TRANSACTION GET_ALL_CUSTOMERS
SET @POUTCUR = CURSOR FOR SELECT CUSTID,CUSTNAME,SALES_YTD,STATUS FROM CUSTOMER0136;
OPEN @POUTCUR
COMMIT TRANSACTION GET_ALL_CUSTOMERS
END TRY
Begin CATCH
ROLLBACK TRANSACTION GET_ALL_CUSTOMERS
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE GET_ALL_PRODUCTS0136 @POUTCUR CURSOR VARYING OUTPUT as 
BEGIN TRY
BEGIN TRANSACTION GET_ALL_PRODUCTS
SET @POUTCUR = CURSOR FOR SELECT PRODID, PRODNAME, SELLING_PRICE, SALES_YTD FROM PRODUCT0136;
OPEN @POUTCUR
COMMIT TRANSACTION GET_ALL_PRODUCTS
END TRY
Begin CATCH
ROLLBACK TRANSACTION GET_ALL_PRODUCTS
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE ADD_LOCATION0136 @ploccode nvarchar(6), @pminqty Int , @pmaxqty Int as 
BEGIN TRY
BEGIN TRANSACTION ADD_LOCATION
INSERT INTO LOCATION0136(LOCID,MINQTY,MAXQTY) VALUES(@ploccode,@pminqty,@pmaxqty)
COMMIT TRANSACTION ADD_LOCATION
END TRY
Begin CATCH
ROLLBACK TRANSACTION ADD_LOCATION
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 2627
THROW 50180, 'Duplicate location ID',1;
ELSE IF ERROR_NUMBER() = 8152 OR @ERRORMESSAGE LIKE '%CHECK_LOCID_LENGTH%'
THROW 50190, 'Location Code length invalid',1;
ELSE IF @ERRORMESSAGE LIKE '%CHECK_MINQTY_RANGE%'
THROW 50200, 'Minimum Qty out of range',1;
ELSE IF @ERRORMESSAGE LIKE '%CHECK_MAXQTY_RANGE%'
THROW 50210, 'Maximum Qty out of range',1
ELSE IF @ERRORMESSAGE LIKE '%CHECK_MAXQTY_GREATER_MIXQTY%'
THROW 50220, 'Minimum Qty larger than Maximum Qty',1;
ELSE 
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

create PROCEDURE ADD_COMPLEX_SALE0136 @pcustid Int, @pprodid Int , @pqty Int, @pdate Nvarchar(10) 
as 
BEGIN TRY
BEGIN TRANSACTION ADD_COMPLEX_SALE
DECLARE @ok2 int;
IF (SELECT CUSTID FROM CUSTOMER0136 WHERE CUSTID = @pcustid) = @Pcustid SET @ok2 =1;
ELSE
THROW 50260, 'Customer ID not found', 1;
IF @pqty < 1 OR @pqty > 999 THROW 50230, 'Sale Quantity outside valid range',1;
DECLARE @pprice MONEY;
set @pprice =(select SELLING_PRICE FROM PRODUCT0136 WHERE PRODID = @pprodid);
declare @amount MONEY;
set @amount = @pqty * @pprice
DECLARE @StatusOfCust NVARCHAR(7);
SET @StatusOfCust = (SELECT STATUS FROM CUSTOMER0136 WHERE CUSTID = @pcustid);
declare @ok int;
IF @StatusOfCust = 'OK' set @ok =1;
ELSE
THROW 50240, 'Customer status is not OK', 1;
DECLARE @ok3 int;
IF (SELECT PRODID FROM PRODUCT0136 WHERE PRODID = @pprodid) = @pprodid SET @ok3 =1;
ELSE
THROW 50270, 'Product ID not found', 1; 
DECLARE @ok4 int;
if @ok =1 AND @ok2 =1 AND @ok3 =1 EXEC UPD_PROD_SALESYTD0136 @pprodid,@amount; 
if @ok =1 AND @ok2 =1 AND @ok3 =1 EXEC UPD_CUST_SALESYTD0136 @pcustid,@amount; 
if @ok =1 AND @ok2 =1 AND @ok3 =1 INSERT INTO SALE0136(SALEID,CUSTID,PRODID,QTY,PRICE,SALEDATE) VALUES(NEXT VALUE FOR SALE_SEQ0136,@pcustid,@pprodid,@pqty,@pprice,@pdate)
COMMIT TRANSACTION ADD_COMPLEX_SALE
END TRY
Begin CATCH
ROLLBACK TRANSACTION ADD_COMPLEX_SALE
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
IF ERROR_NUMBER() = 50240
THROW 50240, 'Customer status is not OK', 1;
ELSE IF ERROR_NUMBER() =50260
THROW 50260, 'Customer ID not found', 1;
ELSE IF ERROR_NUMBER() = 50270
THROW 50270, 'Product ID not found', 1; 
ELSE IF ERROR_NUMBER() = 241
THROW 50250, 'Date not valid',1
ELSE IF ERROR_NUMBER() = 50230
THROW 50230, 'Sale Quantity outside valid range',1
ELSE
THROW 50000, @ERRORMESSAGE, 1 
END CATCH;

GO
create PROCEDURE GET_ALLSALES0136 @POUTCUR CURSOR VARYING OUTPUT AS   
BEGIN TRY
BEGIN TRANSACTION GET_ALLSALES
SET @POUTCUR = CURSOR FOR SELECT SALEID, CUSTID, PRODID, QTY, PRICE, SALEDATE FROM SALE0136;
OPEN @POUTCUR
COMMIT TRANSACTION GET_ALLSALES
END TRY
Begin CATCH
ROLLBACK TRANSACTION GET_ALLSALES
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH;

GO

CREATE PROCEDURE COUNT_PRODUCT_SALES0136 @pdays int AS
BEGIN TRY
BEGIN TRANSACTION COUNT_PRODUCT_SALES
DECLARE @CURRENTDATE DATE;
SET @CURRENTDATE = GETDATE();
declare @mindate DATE;
set @mindate = DATEADD(day,- @pdays,GETDATE())
declare @numofsales INT
set @numofsales =(select count(SALEDATE) FROM SALE0136 WHERE SALEDATE < @CURRENTDATE AND SALEDATE > @mindate)
select CONCAT('number of sales in the past ',@pdays,' : ',@numofsales)
COMMIT TRANSACTION COUNT_PRODUCT_SALES
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION COUNT_PRODUCT_SALES
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

CREATE PROCEDURE DELETE_SALE0136 AS
BEGIN TRY
BEGIN TRANSACTION DELETE_SALE
declare @csaleid INT;
SET @csaleid = (SELECT MIN(SALEID) FROM SALE0136)
DECLARE @ccustid int;
set @ccustid = (select CUSTID FROM SALE0136 WHERE SALEID = @csaleid)
DECLARE @cprodid int;
set @cprodid = (select PRODID FROM SALE0136 WHERE SALEID = @csaleid)
DECLARE @cqty int;
SET @cqty = (select QTY FROM SALE0136 WHERE SALEID = @csaleid)
DECLARE @cprice INT
SET @cprice = (SELECT PRICE FROM SALE0136 WHERE SALEID = @csaleid)
DECLARE @ammount money;
set @ammount = @cqty * @cprice * -1;
DECLARE @ok int;
set @ok = 1;
if @ok = 1 EXEC UPD_CUST_SALESYTD0136 @ccustid,@ammount;
if @ok = 1 EXEC UPD_PROD_SALESYTD0136 @cprodid,@ammount;
if @ok = 1 DELETE FROM SALE0136 WHERE SALEID = @csaleid;
if @ok = 1 SELECT CONCAT('deleted id',@csaleid)
COMMIT TRANSACTION DELETE_SALE
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION DELETE_SALE
IF ERROR_NUMBER() = 6401
THROW 50280, 'No Sale Rows Found',1;
ELSE
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

CREATE PROCEDURE DELETE_ALL_SALES0136 AS
BEGIN TRY
BEGIN TRANSACTION DELETE_ALL_SALES
DELETE  FROM SALE0136;
UPDATE CUSTOMER0136 SET SALES_YTD = 0; 
UPDATE PRODUCT0136 SET SALES_YTD = 0; 
COMMIT TRANSACTION DELETE_ALL_SALES
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION DELETE_ALL_SALES
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

CREATE PROCEDURE DELETE_CUSTOMER0136 @pCustid int AS
BEGIN TRY
BEGIN TRANSACTION DELETE_CUSTOMER
DECLARE @ok INT;
IF (SELECT CUSTID FROM CUSTOMER0136 WHERE CUSTID = @pcustid) = @Pcustid SET @ok =1;
ELSE
THROW 50290, 'Customer ID not found', 1;
IF @ok = 1 DELETE  FROM CUSTOMER0136 WHERE CUSTID = @pCustid;
COMMIT TRANSACTION DELETE_CUSTOMER
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION DELETE_CUSTOMER
IF ERROR_NUMBER() = 50290
THROW 50290, 'Customer ID not found', 1;
ELSE IF ERROR_NUMBER() = 547
THROW 50300, 'Customer cannot be deleted as sales exist', 1;
ELSE
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

CREATE PROCEDURE DELETE_PRODUCT0136 @pProdid int AS
BEGIN TRY
BEGIN TRANSACTION DELETE_PRODUCT
DECLARE @ok INT;
IF (SELECT PRODID FROM PRODUCT0136 WHERE PRODID = @pProdid) = @pProdid SET @ok =1;
ELSE
THROW 50310, 'Product ID not found', 1;
IF @ok = 1 DELETE  FROM PRODUCT0136 WHERE PRODID = @pProdid;
COMMIT TRANSACTION DELETE_PRODUCT
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION DELETE_PRODUCT
IF ERROR_NUMBER() = 50310
THROW 50310, 'Product ID not found', 1;
ELSE IF ERROR_NUMBER() = 547
THROW 50320, 'Product cannot be deleted as sales exist', 1;
ELSE
DECLARE @ERRORMESSAGE NVARCHAR(MAX) = ERROR_MESSAGE();
THROW 50000, @ERRORMESSAGE, 1
END CATCH

GO

--FUNCTION TESTING
EXEC ADD_CUSTOMER0136 1 , a;  
EXEC ADD_CUSTOMER0136 2 , B; 
EXEC ADD_CUSTOMER0136 3 , C; 
EXEC ADD_CUSTOMER0136 4 , D; 
EXEC ADD_CUSTOMER0136 5 , E; 
--EXEC DELETE_ALL_CUSTOMERS0136;
EXEC ADD_PRODUCT0136 1001 , A, 4;
EXEC ADD_PRODUCT0136 1002 , B, 5;
EXEC ADD_PRODUCT0136 1003 , C, 3;
EXEC ADD_PRODUCT0136 1004 , D, 6;
EXEC ADD_PRODUCT0136 1005 , E, 2;
EXEC UPD_CUST_SALESYTD0136 1, 40;
EXEC UPD_CUST_SALESYTD0136 2, 40;
EXEC UPD_PROD_SALESYTD0136 1001, 40;
--EXEC SUM_CUSTOMER_SALESYTD0136;
--EXEC DELETE_ALL_PRODUCTS0136;
--EXEC GET_CUSTOMER_STRING0136 1;
--EXEC GET_PROD_STRING0136 1002;
EXEC UPD_CUSTOMER_STATUS0136 1, 'SUSPEND';
EXEC UPD_CUSTOMER_STATUS0136 1, 'OK';
--EXEC ADD_SIMPLE_SALE0136 3 , 1003 , 2;
EXEC ADD_COMPLEX_SALE0136 3 , 1003 , 2, '2019-10-04';
EXEC ADD_COMPLEX_SALE0136 4 , 1004 , 2, '2019-10-01';
EXEC ADD_LOCATION0136 'TEST1', 20,30
--EXEC COUNT_PRODUCT_SALES0136 10;
--EXEC SUM_PRODUCT_SALESYTD0136;
--EXEC DELETE_ALL_SALES0136
--EXEC DELETE_CUSTOMER0136 1;
--EXEC DELETE_ALL_CUSTOMERS0136;
--EXEC DELETE_PRODUCT0136 1001;
--DECLARE @CUR CURSOR;
--EXEC GET_ALL_CUSTOMERS0136 @POUTCUR = @CUR OUTPUT;
--EXEC GET_ALL_PRODUCTS0136 @POUTCUR = @CUR OUTPUT;
--EXEC GET_ALLSALE0136 @POUTCUR = @CUR OUTPUT;
--FETCH NEXT FROM @CUR
--CLOSE @CUR
--DEALLOCATE @CUR
--FETCH NEXT FROM @CUR
--EXEC DELETE_SALE0136;

--ERROR TESTING
--EXEC ADD_CUSTOMER0136 500 , E;
--EXEC ADD_CUSTOMER0136 1 , E;
--EXEC ADD_PRODUCT0136 1 , E, 2;
--EXEC ADD_PRODUCT0136 1006 , E, 2736;
--EXEC ADD_PRODUCT0136 1005 , E, 2;
--EXEC GET_CUSTOMER_STRING0136 6;
--EXEC UPD_CUST_SALESYTD0136 6, 40;
--EXEC UPD_CUST_SALESYTD0136 1, 4000;
--EXEC UPD_PROD_SALESYTD0136 1000, 40;
--EXEC UPD_PROD_SALESYTD0136 1001, 40000;
--EXEC UPD_CUSTOMER_STATUS0136 1, 'SDFG';
--EXEC UPD_CUSTOMER_STATUS0136 6, 'SUSPEND';
--EXEC ADD_SIMPLE_SALE0136 3 , 1003 , 2000;
--EXEC ADD_SIMPLE_SALE0136 1 , 1003 , 2;
--EXEC ADD_SIMPLE_SALE0136 6 , 1003 , 2;
--EXEC ADD_SIMPLE_SALE0136 3 , 1006 , 2;
--EXEC ADD_COMPLEX_SALE0136 3 , 1003 , 2000,'2019-10-04';
--EXEC ADD_COMPLEX_SALE0136 1 , 1003 , 2,'2019-10-04';
--EXEC ADD_COMPLEX_SALE0136 6 , 1003 , 2,'2019-10-04';
--EXEC ADD_COMPLEX_SALE0136 3 , 1006 , 2,'2019-10-04';
--EXEC ADD_COMPLEX_SALE0136 3 , 1003 , 2,'2019-20-04';
--EXEC DELETE_CUSTOMER0136 3;
--EXEC DELETE_CUSTOMER0136 6;
--EXEC DELETE_PRODUCT0136 1003;
--EXEC DELETE_PRODUCT0136 1006;
--EXEC DELETE_SALE0136;
--EXEC ADD_LOCATION0136 'TEST1', 20,30
--EXEC ADD_LOCATION0136 'TEST22', 20,30
--EXEC ADD_LOCATION0136 'TEST2', 2000,30
--EXEC ADD_LOCATION0136 'TEST2', 20,3000
--EXEC ADD_LOCATION0136 'TEST2', 30,20