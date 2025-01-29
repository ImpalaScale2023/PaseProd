IF OBJECT_ID('tempdb..#TblLotNumber') IS NOT NULL
    DROP TABLE #TblLotNumber;

CREATE TABLE #TblLotNumber (
    LotNumber VARCHAR(100)
);

INSERT INTO #TblLotNumber (LotNumber)
VALUES ('CCW-2408921'),
('CCW-2408922'),
('CCW-2408923'),
('CCW-2410281'),
('CCW-2410481'),
('CCW-2410482'),
('CCW-2410482'),
('CCW-2410483'),
('CCW-2410484'),
('CCW-2410485'),
('CCW-2410486'),
('CCW-2410487'),
('CCW-2410496'),
('CCW-2410497'),
('CCW-2410498'),
('CCW-2410499'),
('CCW-2411771'),
('CCW-2411893'),
('CCW-2411894'),
('CCW-2411895'),
('CCW-2411896'),
('CCW-2411897'),
('CCW-2411898'),
('CCW-2411899'),
('CCW-2411900'),
('CCW-2412052'),
('CCW-2412126'),
('CCW-2412127'),
('CCW-2412201'),
('CCW-2412202'),
('CCW-2412203'),
('CCW-2412237'),
('CCW-2412330'),
('CCW-2412380'),
('CCW-2412381'),
('CCW-2412382'),
('CCW-2412383'),
('CCW-2412384'),
('CCW-2412423'),
('CCW-2412466'),
('CCW-2412467'),
('CCW-2412520'),
('CCW-2412555'),
('CCW-2412556'),
('CCW-2412557'),
('CCW-2412599'),
('CCW-2412614'),
('CCW-2412708'),
('CCW-2412709'),
('CCW-2412710'),
('CCW-2412711'),
('CCW-2412712'),
('CCW-2412873'),
('CCW-2412894'),
('CCW-2412896'),
('CCW-2412942'),
('CCW-2500026'),
('CCW-2500059'),
('CCW-2500060'),
('CCW-2500061'),
('CCW-2500062'),
('CCW-2500083'),
('CCW-2500124'),
('CCW-2500211'),
('CCW-2500212'),
('CCW-2500241'),
('CCW-2500242'),
('CCW-2500243'),
('CCW-2500244'),
('CCW-2500245'),
('CCW-2500246'),
('CCW-2500247'),
('CCW-2500284'),
('CCW-2500285'),
('CCW-2500286'),
('CCW-2500287'),
('CCW-2500288'),
('CCW-2500289'),
('CCW-2500290'),
('CCW-2500291'),
('CCW-2500292'),
('CCW-2500293'),
('CCW-2500294'),
('CCW-2500312'),
('CCW-2500313'),
('CCW-2500314'),
('CCW-2500315'),
('CCW-2500316'),
('CCW-2500317'),
('CCW-2500318'),
('CCW-2500323'),
('CCW-2500386'),
('CCW-2500388'),
('CCW-2500408'),
('CCW-2500409'),
('CCW-2500462'),
('CCW-2500478'),
('CCW-2500479'),
('CCW-2500570'),
('CCW-2500596'),
('CCW-2500597'),
('CCW-2500637'),
('CCW-2500687'),
('CCW-2500688'),
('CCW-2500689'),
('CCW-2500690'),
('CCW-2500745'),
('CCW-2500746'),
('CCW-2500784'),
('CCW-2500785'),
('CCW-2500940')

SELECT -- Validar si son los registro que se van a modificar
*
FROM dbo.Weighing
WHERE IdCompany = 1
AND IdCompanyBranch = 1
AND DeletedFlag = 0
AND LotNumber IN (SELECT LotNumber FROM #TblLotNumber)

SELECT -- Validar si son los registro que se van a modificar
*
FROM dbo.UC_MASTER_RECEIPT_FWD
WHERE WHSE_ID = 'CCW'
AND DeletedFlag = 0
AND ADRNAM_SUP IN (SELECT LotNumber FROM #TblLotNumber)

RETURN -- Retirar si se quiere modificar

UPDATE dbo.UC_MASTER_RECEIPT_FWD
SET ADRNAM_SUP = 'METCO',
UpdatedDate = dbo.FechaUTC(1, 1),
UpdatedIdCompany = 1,
UpdatedIdUser = 1
WHERE WHSE_ID = 'CCW'
AND DeletedFlag = 0
AND ADRNAM_SUP IN (SELECT LotNumber FROM #TblLotNumber)

RETURN -- Retirar si se quiere modificar

UPDATE dbo.Weighing SET
SupplierName = 'METCO',
UpdatedDate = dbo.FechaUTC(1, 1),
UpdatedIdCompany = 1,
UpdatedIdUser = 1
WHERE IdCompany = 1
AND IdCompanyBranch = 1
AND DeletedFlag = 0
AND LotNumber IN (SELECT LotNumber FROM #TblLotNumber)
