CREATE TABLE [dbo].[RunningDailyQtyRevenue]
(
[Season] [nvarchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TicketTypeName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SaleDate] [date] NULL,
[DaysOfRenewalCycle] [int] NULL,
[DailyRevenue] [decimal] (18, 6) NULL,
[RunningSales] [decimal] (18, 6) NULL,
[DailyQty] [int] NULL,
[RunningQty] [int] NULL
)
GO
