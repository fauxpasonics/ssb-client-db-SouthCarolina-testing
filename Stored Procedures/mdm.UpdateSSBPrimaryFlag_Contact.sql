SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [mdm].[UpdateSSBPrimaryFlag_Contact]
(
	@ClientDB VARCHAR(50)
)
AS
BEGIN

/* mdm.UpdateSSBPrimaryFlag - Creates/Updates SSB Primary Flag
* created: 11/18/2014 kwyss
* modified:  04/20/2015 - GHolder -- Added @ClientDB parameter and updated sproc to use dynamic SQL
*7/27/2015 - Kwyss - modified to use configurable business rules
*
*/

---DECLARE @clientdb varchar(50) = 'PSP'

IF (SELECT @@VERSION) LIKE '%Azure%'
BEGIN
SET @ClientDB = ''
END

IF (SELECT @@VERSION) NOT LIKE '%Azure%'
BEGIN
SET @ClientDB = @ClientDB + '.'
END


DECLARE @SQL nvarchar(max) = ' ';
DECLARE @SQL2 nvarchar(max) = ' ';
DECLARE @FieldList nVARCHAR(MAX) = '';
DECLARE @JoinList nVARCHAR(MAX)  = '';
DECLARE @RankingLIST nVARCHAR(MAX) = '';
DECLARE @GetPreSQL NVARCHAR(MAX) = '';
DECLARE @PreSQLQuery NVARCHAR(MAX) = '';

--- Get all criteria pre-sql and run it once.

SET @GetPreSQl = @GetPreSQL
+' SELECT  @PreSQLQuery = COALESCE(@PreSQLQuery + '' '', '''') + c.PreSQL ' + CHAR(13)
+' FROM  ' + @clientDb + 'mdm.criteria c ' + CHAR(13)
+' where c.criteriaID in (select distinct criteriaid from ' 
+ @clientDb + 'mdm.compositebusinessrules) and isnull(presql, '''') != ''''' + CHAR(13)


EXEC sp_executesql @GetPreSQL
        , N'@PreSQLQuery nvarchar(max) OUTPUT'
       ,  @PreSQLQuery OUTPUT

---Print @PreSQLQuery


EXEC sp_executesql @PreSQLQuery

--- Get Criteria for Primary Record
SET @SQL2 = @SQL2

+' SELECT @FieldList = COALESCE(@FieldList + '', '', '''') + c.CriteriaField + '' as ['' + c.criteria + '']''' + CHAR(13)
+' , @JoinList = COALESCE(@JoinList + '' '', '''') + ISNULL(c.CriteriaJoin, '''') ' + CHAR(13)
+' ,@RankingList = COALESCE(@RankingList + '' '', '''') + ''['' + c.criteria + ''] '' + c.CriteriaOrder + '',''' + CHAR(13)
+' FROM ' + @clientDb + 'mdm.compositebusinessrules a ' + CHAR(13)
+' INNER JOIN ' + @clientDb + 'mdm.element b ' + CHAR(13)
+' ON a.elementid = b.elementid ' + CHAR(13)
+' INNER JOIN ' + @clientDb + 'mdm.criteria c ' + CHAR(13)
+' ON c.criteriaID = a.criteriaID ' + CHAR(13)
+' WHERE element = ''Primary Record''' + CHAR(13)
+' ORDER BY priority; ' + CHAR(13)

---PRINT @SQL2

EXEC sp_executesql @SQL2
        , N'@FieldList nvarchar(max) OUTPUT, @JoinList nvarchar(max) OUTPUT, @RankingLIST nvarchar(max) OUTPUT'
       , @FieldList OUTPUT
       , @JoinList OUTPUT
       , @RankingLIST OUTPUT

---PRINT @Rankinglist



---Get Data
SET @SQL = @SQL
+ 'IF Exists (Select * from ' + @clientDb + 'Information_Schema.Tables where Table_name = ''tmp_flag_data'')'+ CHAR(13) 
+ 'drop table ' + @clientDb + 'mdm.tmp_flag_data;'+ CHAR(13) 
+ 'SELECT ssbid.dimcustomerid ' + CHAR(13) 
+ ',ssbid.sourcesystem ' + CHAR(13) 
+ ',ssbid.ssid ' + CHAR(13) 
+ ',ssbid.ssb_crmsystem_acct_id  ' + CHAR(13)
+ ',ssbid.SSB_CRMSYSTEM_CONTACT_ID  ' + CHAR(13)
+ ',ssbid.SSB_CRMSYSTEM_PRIMARY_FLAG    ' + CHAR(13)
+ ',ssbid.SSB_CRMSYSTEM_ACCT_PRIMARY_FLAG ' + CHAR(13)
+  @FieldList  
+ ' INTO ' + @clientDb + 'mdm.tmp_flag_data '
+ ' FROM ' + @clientDb + 'dbo.dimcustomerssbid ssbid ' + CHAR(13)
+ 'INNER JOIN ' + @clientDb + 'dbo.dimcustomer dimcust ' + CHAR(13)
+ 'ON ssbid.DimCustomerId = dimcust.dimcustomerid ' + CHAR(13)
+   @JoinList   + CHAR(13)
+ ' WHERE dimcust.isdeleted = 0; ' + CHAR(13)



SET @sql = @sql
	+ 'Insert into ' + @clientDb + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Primary Flag'', ''tmp_flag_data'', @@ROWCOUNT);' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql
	+ '---Update any deleted records to 0 (should not be primary)' + CHAR(13)
	+ 'Update ssbid' + CHAR(13)
	+ 'set ssb_crmsystem_primary_flag = 0, ssb_crmsystem_acct_primary_flag = 0' + CHAR(13)
	+ 'from ' + @clientDb + 'dbo.dimcustomerssbid ssbid' + CHAR(13)
	+ 'inner join ' + @clientDb + 'dbo.dimcustomer dimcust' + CHAR(13)
	+ 'on ssbid.dimcustomerid = dimcust.dimcustomerid' + CHAR(13)
	+ 'where dimcust.isdeleted = 1;'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @clientDb + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Primary Flag'', ''remove deleted records'', @@ROWCOUNT);' 
SET @sql = @sql + CHAR(13) + CHAR(13)


SET @sql = @sql
	+ 'Update ssbid' + CHAR(13)
	+ 'set ssb_crmsystem_primary_flag = case when ranking = 1 then 1 else 0 end ' + CHAR(13)
	+ 'from ' + @clientDb + 'dbo.dimcustomerssbid ssbid' + CHAR(13)
	+ 'inner join (' + CHAR(13)
	+ 'select *,' + CHAR(13)
	+ 'rank() over (partition by ssb_crmsystem_contact_id order by ' + @RankingList + ' ssb_crmsystem_primary_flag desc, DimCustomerId) as ranking' + CHAR(13)
	+ 'from ' + @clientDb + 'mdm.tmp_flag_data) b' + CHAR(13)
	+ 'on ssbid.DimCustomerId = b.dimcustomerid;'
SET @sql = @sql + CHAR(13) + CHAR(13)

SET @sql = @sql
	+ 'Insert into ' + @clientDb + 'mdm.auditlog (logdate, mdm_process, process_step, cnt)' + CHAR(13)
	+ 'values (current_timestamp, ''Primary Flag'', ''set contact primary'', @@ROWCOUNT);' 
SET @sql = @sql + CHAR(13) + CHAR(13)

---PRINT @SQL

EXEC sp_executesql @sql

END


GO
