SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [ro].[vw_DimSeatType] AS ( SELECT * FROM dbo.DimSeatType_V2 (NOLOCK) )
GO