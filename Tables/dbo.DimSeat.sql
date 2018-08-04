CREATE TABLE [dbo].[DimSeat]
(
[DimSeatId] [int] NOT NULL IDENTITY(1, 1),
[DimArenaId] [int] NOT NULL,
[ManifestId] [smallint] NULL,
[SectionName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectionDesc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SectionSort] [int] NULL,
[RowName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RowSort] [int] NULL,
[Seat] [int] NULL,
[DefaultClass] [int] NULL,
[DefaultPriceCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSUpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSCreatedDate] [datetime] NULL,
[SSUpdatedDate] [datetime] NULL,
[SSID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSID_manifest_id] [int] NULL,
[SSID_section_id] [int] NULL,
[SSID_row_id] [int] NULL,
[SSID_seat] [int] NULL,
[SourceSystem] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeltaHashKey] [binary] (32) NULL,
[CreatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdatedBy] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeat__Created__7E37BEF6] DEFAULT (getdate()),
[UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__DimSeat__Updated__7F2BE32F] DEFAULT (getdate()),
[IsDeleted] [bit] NOT NULL CONSTRAINT [DF__DimSeat__IsDelet__00200768] DEFAULT ((0)),
[DeleteDate] [datetime] NULL CONSTRAINT [DF__DimSeat__DeleteD__01142BA1] DEFAULT ((0)),
[Config_Location] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config_IsFactInventoryEligible] [bit] NULL
)
GO
ALTER TABLE [dbo].[DimSeat] ADD CONSTRAINT [PK_DimSeat] PRIMARY KEY CLUSTERED  ([DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_Config_Location] ON [dbo].[DimSeat] ([Config_Location])
GO
CREATE NONCLUSTERED INDEX [idx_DimSeat_Arena_Manifest_Section] ON [dbo].[DimSeat] ([DimArenaId], [ManifestId], [SectionName])
GO
CREATE NONCLUSTERED INDEX [ix_dimseat_isdeleted_include] ON [dbo].[DimSeat] ([IsDeleted]) INCLUDE ([DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_DimSeat_ManifestID_IncludeList] ON [dbo].[DimSeat] ([ManifestId]) INCLUDE ([DefaultClass], [DefaultPriceCode], [DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_DimSeat_ManifestId_SourceSystem] ON [dbo].[DimSeat] ([ManifestId], [SourceSystem]) INCLUDE ([Config_IsFactInventoryEligible], [DefaultClass], [DefaultPriceCode], [DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_DimSeat_ManifestId_SourceSystem_ConfigIsFactInventoryEligible] ON [dbo].[DimSeat] ([ManifestId], [SourceSystem], [Config_IsFactInventoryEligible]) INCLUDE ([DefaultClass], [DefaultPriceCode], [DimSeatId])
GO
CREATE NONCLUSTERED INDEX [IDX_RowName] ON [dbo].[DimSeat] ([RowName])
GO
CREATE NONCLUSTERED INDEX [IDX_Seat] ON [dbo].[DimSeat] ([Seat], [SSID_section_id], [SSID_row_id])
GO
CREATE NONCLUSTERED INDEX [IDX_SectionName] ON [dbo].[DimSeat] ([SectionName])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_LoadKey] ON [dbo].[DimSeat] ([SourceSystem], [SSID_manifest_id], [SSID_section_id], [SSID_row_id], [SSID_seat])
GO
CREATE NONCLUSTERED INDEX [IDX_BusinessKey] ON [dbo].[DimSeat] ([SSID_manifest_id], [SSID_section_id], [SSID_row_id], [SSID_seat])
GO
CREATE NONCLUSTERED INDEX [NCIX_DimSeat_SSID_section_id] ON [dbo].[DimSeat] ([SSID_section_id]) WITH (DATA_COMPRESSION = PAGE)
GO
CREATE NONCLUSTERED INDEX [IDX_UpdatedDate] ON [dbo].[DimSeat] ([UpdatedDate])
GO
