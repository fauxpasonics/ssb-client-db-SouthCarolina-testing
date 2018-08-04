CREATE TABLE [dbo].[HOB_TicketSalesBySchoolYear]
(
[SchoolYear] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sport] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CYSeatDonationQty] [int] NULL,
[CYSeatDonationRevenue] [decimal] (18, 6) NULL,
[CYTickets] [int] NULL,
[CYRevenue] [decimal] (18, 6) NULL,
[PYSeatDonationQty] [int] NULL,
[PYSeatDonationRevenue] [decimal] (18, 6) NULL,
[PYTickets] [int] NULL,
[PYRevenue] [decimal] (18, 6) NULL,
[CY] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PY] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
