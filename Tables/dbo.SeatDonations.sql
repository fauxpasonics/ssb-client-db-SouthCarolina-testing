CREATE TABLE [dbo].[SeatDonations]
(
[SeatDonationID] [int] NOT NULL IDENTITY(1, 1),
[DimPriceCodeID] [int] NULL,
[PriceCode] [nvarchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PriceCodeDesc] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Price] [decimal] (18, 6) NULL,
[SeatDonationPrice] [decimal] (18, 6) NULL,
[SeatDonationType] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimSeasonID] [int] NULL,
[SeasonName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SeasonYear] [int] NULL,
[NeedsReview] [bit] NULL,
[ReviewCompletedDate] [datetime] NULL,
[TicketPrice] [decimal] (18, 6) NULL
)
GO
