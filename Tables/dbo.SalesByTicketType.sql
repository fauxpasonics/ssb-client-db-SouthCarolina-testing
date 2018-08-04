CREATE TABLE [dbo].[SalesByTicketType]
(
[Season] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CYTickets] [int] NULL,
[CYRevenue] [decimal] (18, 6) NULL,
[PY] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PYTickets] [int] NULL,
[PYRevenue] [decimal] (18, 6) NULL
)
GO
