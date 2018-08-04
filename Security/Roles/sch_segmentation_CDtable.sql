CREATE ROLE [sch_segmentation_CDtable]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'sch_segmentation_CDtable', N'svcsegmentation'
GO
