CREATE TABLE [zzz].[ods__TM_CustAddress_20170516]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[cust_name_id] [int] NULL,
[cust_address_id] [int] NULL,
[address_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_type_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[acct_id] [int] NULL,
[primary_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[street_addr_2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[country] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[county] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[solicit_mail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[solicit_mail_registry] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[carrier_route] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seasonal] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_date] [datetime] NULL,
[end_date] [datetime] NULL,
[city_state_zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_prefix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_prefix2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_first] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_middle] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_last] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_suffix] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_title] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[company_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nick_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[maiden_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salutation] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_last_first_mi] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[full_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[primary_code] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address_type_primary_ind] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name_type] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner_name] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[owner_name_full] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InsertDate] [datetime] NULL,
[UpdateDate] [datetime] NULL,
[SourceFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HashKey] [binary] (32) NULL
)
GO
ALTER TABLE [zzz].[ods__TM_CustAddress_20170516] ADD CONSTRAINT [PK__TM_CustA__3213E83F89A141C3] PRIMARY KEY CLUSTERED  ([id])
GO
