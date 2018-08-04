SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--[rpt].[ShowRate] '2016-2017 Women''s Basketball'
CREATE PROCEDURE [rpt].[ShowRate] (@Season NVARCHAR(50))
AS

--DECLARE @Season NVARCHAR(50) = '2016-2017 Women''s Basketball'

SELECT 
	seat.SectionName, 
	SUM(total.QtySeat) Total, 
	SUM(CASE WHEN DimTicketTypeId IN (1,5) THEN total.QtySeat END) AS Season, 
	SUM(CASE WHEN DimTicketTypeId IN (4) THEN total.QtySeat END) AS [Group],
	SUM(CASE WHEN DimTicketTypeId IN (3) THEN total.QtySeat END) AS Single,
	SUM(CASE WHEN DimTicketTypeId IN (2, 6, 7) THEN total.QtySeat END) AS [Mini/Flex],
	SUM(CASE WHEN DimTicketTypeId IN (-1) THEN total.QtySeat END) AS Misc,
	SUM(CASE WHEN TicketClassType = 'Young Alumni' THEN  total.QtySeat END) AS [YoungAlumni]
FROM dbo.DimSeasonHeader sh
INNER JOIN dbo.DimSeason s ON sh.DimSeasonHeaderId = s.Config_DefaultDimSeasonHeaderId
INNER JOIN dbo.DimSeat seat (NOLOCK) ON seat.DimArenaId = sh.DimArenaId
LEFT OUTER JOIN (
		SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtySeat, CASE WHEN tc.TicketClassType = 'Young Alumni' THEN TicketClassType ELSE 'All' END AS TicketClassType, DimTicketTypeId
		FROM dbo.FactTicketSales f (NOLOCK)
		INNER JOIN dbo.DimSeason ds (NOLOCK)
			ON  f.DimSeasonId = ds.DimSeasonId
		INNER JOIN dbo.DimSeasonHeader dsh (NOLOCK)
			ON  ds.Config_DefaultDimSeasonHeaderId = dsh.DimSeasonHeaderId
		INNER JOIN dbo.DimTicketClass tc (NOLOCK) 
			ON  tc.DimTicketClassId = f.DimTicketClassId
		WHERE dsh.SeasonName = @Season
		GROUP BY f.DimSeasonId, f.DimSeatIdStart, CASE WHEN tc.TicketClassType = 'Young Alumni' THEN TicketClassType ELSE 'All' END, DimTicketTypeId
	) total 
	ON  seat.DimSeatId = total.DimSeatIdStart 
	AND s.DimSeasonId = total.DimSeasonId
WHERE sh.SeasonName = @Season
GROUP BY seat.SectionName
ORDER BY
	CASE ISNUMERIC(ISNULL(seat.SectionName,'None'))  
        WHEN 1 THEN REPLICATE('0', 4 - LEN(ISNULL(seat.SectionName,'None'))) + ISNULL(seat.SectionName,'None') 
        ELSE ISNULL(seat.SectionName,'None') END

--SELECT seat.SectionName, 
--SUM(total.QtyTotal) Total, SUM(QtySTH) Season, SUM(grp.QtyGrp) 'Group', SUM(sg.QtySg) Single, SUM(mp.QtyMp) 'Mini/Flex', SUM(misc.QtyMisc) Misc, SUM(QtyYA) 'YoungAlumni'
--FROM dbo.DimSeasonHeader sh
--JOIN dbo.DimSeason s ON sh.DimSeasonHeaderId = s.Config_DefaultDimSeasonHeaderId
--JOIN dbo.DimSeat seat (NOLOCK) ON seat.DimArenaId = sh.DimArenaId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtyTotal
--	FROM dbo.FactTicketSales f (NOLOCK)
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) total ON seat.DimSeatId = total.DimSeatIdStart AND s.DimSeasonId = total.DimSeasonId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtyYA
--	FROM dbo.FactTicketSales f (NOLOCK)
--	JOIN dbo.DimTicketClass tc (NOLOCK) ON tc.DimTicketClassId = f.DimTicketClassId
--	WHERE tc.TicketClassType = 'Young Alumni'
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) ya ON seat.DimSeatId = ya.DimSeatIdStart AND s.DimSeasonId = ya.DimSeasonId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtySTH
--	FROM dbo.FactTicketSales f (NOLOCK)
--	WHERE f.DimTicketTypeId IN (1, 5)
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) sth ON seat.DimSeatId = sth.DimSeatIdStart AND s.DimSeasonId = sth.DimSeasonId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtyGrp
--	FROM dbo.FactTicketSales f (NOLOCK)
--	WHERE f.DimTicketTypeId = 4
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) grp ON seat.DimSeatId = grp.DimSeatIdStart AND s.DimSeasonId = grp.DimSeasonId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtySg
--	FROM dbo.FactTicketSales f (NOLOCK)
--	WHERE f.DimTicketTypeId = 3
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) sg ON seat.DimSeatId = sg.DimSeatIdStart AND s.DimSeasonId = sg.DimSeasonId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtyMp
--	FROM dbo.FactTicketSales f (NOLOCK)
--	WHERE f.DimTicketTypeId IN (2, 6, 7)
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) mp ON seat.DimSeatId = mp.DimSeatIdStart AND s.DimSeasonId = mp.DimSeasonId
--LEFT JOIN (
--	SELECT f.DimSeasonId, f.DimSeatIdStart, SUM(f.QtySeat) QtyMisc
--	FROM dbo.FactTicketSales f (NOLOCK)
--	WHERE f.DimTicketTypeId = -1
--	GROUP BY f.DimSeasonId, f.DimSeatIdStart
--	) misc ON seat.DimSeatId = misc.DimSeatIdStart AND s.DimSeasonId = misc.DimSeasonId
--WHERE sh.SeasonName = @Season
--GROUP BY seat.SectionName
--ORDER BY --seat.SectionName
--	case IsNumeric(ISNULL(seat.SectionName,'None'))  
--        when 1 then Replicate('0', 4 - Len(ISNULL(seat.SectionName,'None'))) + ISNULL(seat.SectionName,'None') 
--        else ISNULL(seat.SectionName,'None') end
GO
