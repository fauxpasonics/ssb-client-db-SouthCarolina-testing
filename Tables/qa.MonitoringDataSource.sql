CREATE TABLE [qa].[MonitoringDataSource]
(
[MonitoringDataSourceId] [int] NOT NULL IDENTITY(1, 1),
[DataSourceName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TableName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ColumnName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColumnOperator] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TimeDelayHours] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FilterClause] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MonitoringDataSource_CreatedBy] DEFAULT (suser_sname()),
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MonitoringDataSource_UpdatedBy] DEFAULT (suser_sname()),
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_MonitoringDataSource_CreatedDate] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF_MonitoringDataSource_UpdatedDate] DEFAULT (getdate()),
[IsActive] [bit] NOT NULL CONSTRAINT [DF_MonitoringDataSource_IsActive] DEFAULT ((1))
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [qa].[MonitoringDataSource_Updated]
   ON  [qa].[MonitoringDataSource]
   AFTER UPDATE
AS 
BEGIN
      SET NOCOUNT ON;
      UPDATE      MDS
      SET         MDS.UpdatedBy = SUSER_NAME(),
                  MDS.UpdatedDate = GETDATE()
      FROM  qa.MonitoringDataSource AS MDS
            INNER JOIN Inserted AS I ON I.MonitoringDataSourceId = MDS.MonitoringDataSourceId;
END
GO
ALTER TABLE [qa].[MonitoringDataSource] ADD CONSTRAINT [PK_MonitoringDataSource] PRIMARY KEY CLUSTERED  ([MonitoringDataSourceId]) WITH (DATA_COMPRESSION = PAGE)
GO
