SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/****** CHANGE LOG **************

3/21/2017 - created by AMeitin to test Kings version of CRM API view for Primary Transactions

*********************************/



CREATE VIEW [rpt].[vw_RetailTicketBase]
AS
    ( SELECT    a.*
      FROM      ( SELECT    *
                  FROM      ( SELECT    *
                                      , ROW_NUMBER() OVER ( PARTITION BY retail.section_name,
                                                            retail.row_name,
                                                            sl.Seat, retail.retail_event_id ORDER BY retail.transaction_datetime DESC ) RowRank
                              FROM      ods.TM_RetailNonTicket retail
                                        INNER JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN retail.first_seat
                                                              AND
                                                              retail.last_seat
                              WHERE     refund_flag = 0
                            ) aa
                  WHERE     aa.RowRank = 1
                ) a
                LEFT JOIN ( SELECT  *
                            FROM    ( SELECT    *
                                              , ROW_NUMBER() OVER ( PARTITION BY retail.section_name,
                                                              retail.row_name,
                                                              sl.Seat, retail.retail_event_id ORDER BY retail.transaction_datetime DESC ) RowRank
                                      FROM      ods.TM_RetailNonTicket retail
                                                INNER JOIN dbo.Lkp_SeatList sl ON sl.Seat BETWEEN retail.first_seat
                                                              AND
                                                              retail.last_seat
                                      WHERE     refund_flag IN ( 1 )
                                    ) bb
                            WHERE   bb.RowRank = 1
                          ) b ON b.section_name = a.section_name
                                 AND b.row_name = a.row_name
                                 AND b.Seat = a.Seat
								 AND b.retail_event_id = a.retail_event_id
      WHERE     a.transaction_datetime > ISNULL(b.transaction_datetime,
                                                '1900-01-01')
    )



GO
