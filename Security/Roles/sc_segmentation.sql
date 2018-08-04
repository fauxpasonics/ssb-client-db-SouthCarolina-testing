CREATE ROLE [sc_segmentation]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'sc_segmentation', N'svc_sc_segmentation'
GO
GRANT CREATE TABLE TO [sc_segmentation]
