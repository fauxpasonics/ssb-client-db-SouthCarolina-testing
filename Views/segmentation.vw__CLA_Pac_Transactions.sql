SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [segmentation].[vw__CLA_Pac_Transactions]
AS (
				  SELECT    rb.SEASON
                          , Season.NAME AS SEASON_NAME
						  , SSBID.SSB_CRMSYSTEM_CONTACT_ID
                          , rb.CUSTOMER
                          , rb.ITEM
                          , Item.NAME ITEM_NAME
                          , rb.I_PT
                          , PT.NAME I_PT_NAME
                          , rb.I_PL
                          , PRLev.PL_NAME
                          , rb.I_PRICE
                          , rb.I_DAMT
                          , rb.I_OQTY
                          , (rb.I_OQTY * rb.I_PRICE) AS ORDTOTAL
                          , rb.I_PAY AS PAIDTOTAL
                          , rb.I_DATE
 FROM      dbo.TK_ODET rb WITH (NOLOCK)
                            LEFT JOIN dbo.TK_ITEM Item WITH (NOLOCK) ON Item.ITEM COLLATE SQL_Latin1_General_CP1_CI_AS = rb.ITEM
                                                          AND Item.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = rb.SEASON
                            LEFT JOIN dbo.TK_PRTYPE PT WITH (NOLOCK) ON PT.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = Item.SEASON
                                                          AND PT.PRTYPE COLLATE SQL_Latin1_General_CP1_CI_AS = rb.I_PT
                            LEFT JOIN dbo.TK_SEASON Season WITH (NOLOCK) ON Season.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = rb.SEASON
                            --LEFT JOIN dbo.TK_CTYPE CType WITH (NOLOCK) ON CType.TYPE COLLATE SQL_Latin1_General_CP1_CI_AS = rb.CUSTOMER_TYPE
                            LEFT JOIN dbo.TK_PTABLE_PRLEV PRLev WITH (NOLOCK) ON PRLev.SEASON COLLATE SQL_Latin1_General_CP1_CI_AS = rb.SEASON
                                                              AND PRLev.PTABLE COLLATE SQL_Latin1_General_CP1_CI_AS = rb.ITEM
                                                              AND PRLev.PL COLLATE SQL_Latin1_General_CP1_CI_AS = rb.I_PL
							INNER JOIN dbo.dimcustomerssbid SSBID WITH (NOLOCK) 
									  ON SSBID.SSID COLLATE SQL_Latin1_General_CP1_CS_AS 
											= rb.CUSTOMER COLLATE SQL_Latin1_General_CP1_CS_AS  
										 AND SSBID.SourceSystem = 'PAC_CLA'

					WHERE rb.SEASON LIKE 'CC%'
					AND rb.SEASON IN ('CC15', 'CC16')
)            






GO
