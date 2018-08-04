CREATE TABLE [dbo].[Season_SchoolYear]
(
[SeasonSchoolYearId] [int] NOT NULL IDENTITY(1, 1),
[SeasonCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SchoolYear] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrevSchoolYear] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PYSeasonCode] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[Season_SchoolYear] ADD CONSTRAINT [PK_SeasonSchoolYear] PRIMARY KEY CLUSTERED  ([SeasonSchoolYearId])
GO
