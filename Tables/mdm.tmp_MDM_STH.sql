CREATE TABLE [mdm].[tmp_MDM_STH]
(
[DimCustomerId] [int] NOT NULL,
[DNR] [int] NULL,
[STH] [int] NULL,
[MaxSeatCount] [int] NULL,
[MaxPurchaseDate] [datetime] NULL,
[AccountId] [int] NULL
)
GO
CREATE CLUSTERED INDEX [ix_MDM_STH] ON [mdm].[tmp_MDM_STH] ([DimCustomerId])
GO
