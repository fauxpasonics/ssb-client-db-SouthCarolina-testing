CREATE TABLE [qa].[MonitoringDataSourceAudit]
(
[MonitoringDataSourceAuditID] [int] NOT NULL IDENTITY(1, 1),
[MonitoringDataSourceId] [int] NOT NULL,
[DataSourceName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceUpdatedDate] [datetime] NULL,
[Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_MonitoringDataSourceAudit_CreatedDate] DEFAULT (getdate())
)
WITH
(
DATA_COMPRESSION = PAGE
)
GO
ALTER TABLE [qa].[MonitoringDataSourceAudit] ADD CONSTRAINT [PK_MonitoringDataSourceAudit] PRIMARY KEY CLUSTERED  ([MonitoringDataSourceAuditID]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [NCIX_MonitoringDataSourceAudit_MonitoringDataSourceId] ON [qa].[MonitoringDataSourceAudit] ([MonitoringDataSourceId]) WITH (DATA_COMPRESSION = PAGE)
GO
ALTER TABLE [qa].[MonitoringDataSourceAudit] ADD CONSTRAINT [FK_MonitoringDataSourceAudit_MonitoringDataSourceId] FOREIGN KEY ([MonitoringDataSourceId]) REFERENCES [qa].[MonitoringDataSource] ([MonitoringDataSourceId])
GO
