CREATE TABLE [dbo].[HOB_SeasonTicketSalesBySchoolYear]
(
[SchoolYear] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sport] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CY] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PY] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CY_Tickets] [int] NULL,
[PY_Tickets] [int] NULL,
[CY_Revenue] [decimal] (18, 6) NULL,
[PY_Revenue] [decimal] (18, 6) NULL,
[CY_CntNew] [int] NULL,
[PY_CntNew] [int] NULL,
[CY_PctRenew] [decimal] (15, 2) NULL,
[PY_PctRenew] [decimal] (15, 2) NULL
)
GO
