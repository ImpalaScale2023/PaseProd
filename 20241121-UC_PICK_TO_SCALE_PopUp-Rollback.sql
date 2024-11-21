-- UC_PICK_TO_SCALE_PopUp 1, '', 1, 10
ALTER PROCEDURE [dbo].[UC_PICK_TO_SCALE_PopUp]
@IdCompanyBranch INT,
@Search VARCHAR(200),
@PageIndex INT,
@PageSize INT
AS
SET NOCOUNT ON

DECLARE @WHSE_ID VARCHAR(5)
SELECT @WHSE_ID = CodeCompanyBranch FROM CompanyBranch WHERE IdCompanyBranch = @IdCompanyBranch

--#UC_PICK_COMPLETE
IF OBJECT_ID('tempdb.dbo.#UC_PICK_COMPLETE') IS NOT NULL
BEGIN
  TRUNCATE TABLE dbo.#UC_PICK_COMPLETE;
END
ELSE
BEGIN
	CREATE TABLE dbo.#UC_PICK_COMPLETE(
		[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		[SHIP_ID] VARCHAR(30) NOT NULL
		)

	CREATE NONCLUSTERED INDEX [IX_TmpUCPICKCOMPLETE_SHIPID] ON dbo.#UC_PICK_COMPLETE
	(
		[SHIP_ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
END



INSERT INTO dbo.#UC_PICK_COMPLETE (SHIP_ID)
SELECT 
pc.SHIP_ID
FROM dbo.UC_PICK_COMPLETE pc 

--#UC_PICK_TO_SCALE
IF OBJECT_ID('tempdb.dbo.#UC_PICK_TO_SCALE') IS NOT NULL
BEGIN
  TRUNCATE TABLE dbo.#UC_PICK_TO_SCALE;
END
ELSE
BEGIN
	CREATE TABLE dbo.#UC_PICK_TO_SCALE(
		[Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
		[ORDNUM] VARCHAR(20) NOT NULL
	)
END

INSERT INTO dbo.#UC_PICK_TO_SCALE
(ORDNUM)
SELECT
uc.ORDNUM
FROM UC_PICK_TO_SCALE uc
LEFT JOIN SeaPort sp ON sp.IdSeaPort = uc.OriginIdSeaPort
WHERE 
NOT EXISTS (SELECT SHIP_ID FROM dbo.#UC_PICK_COMPLETE ucp
					WHERE uc.SHIP_ID = ucp.SHIP_ID)
AND
(
        uc.ORDNUM LIKE '%' + @Search + '%' 
		OR uc.CLIENT_ID LIKE '%' + @Search + '%' 
		OR uc.SEGNAM LIKE '%' + @Search + '%' 
		OR uc.TRNTYP LIKE '%' + @Search + '%' 
		OR uc.WHSE_ID LIKE '%' + @Search + '%' 
		OR uc.shiP_ID LIKE '%' + @Search + '%' 
		OR uc.WAVENUM LIKE '%' + @Search + '%' 
		OR uc.PRTNUM LIKE '%' + @Search + '%' 
		OR uc.INV_ATTR_STR1 LIKE '%' + @Search + '%' 
		OR uc.QTY LIKE '%' + @Search + '%' 
		OR uc.INV_ATTR_STR5 LIKE '%' + @Search + '%' 
		OR uc.STOLOC LIKE '%' + @Search + '%' 
		OR uc.UC_CONVEYOR LIKE '%' + @Search + '%' 
		OR uc.UC_CONTAINER_FLG LIKE '%' + @Search + '%' 
		OR uc.VC_SAMPLE_CLIENT LIKE '%' + @Search + '%' 
		OR uc.VC_SAMPLE_PROD LIKE '%' + @Search + '%' 
		OR uc.UC_SAMP_PL LIKE '%' + @Search + '%' 
		OR uc.EXTRL_SRVYR LIKE '%' + @Search + '%'
		OR uc.adnL_TST_REQD LIKE '%' + @Search + '%'
    )
AND uc.WHSE_ID = @WHSE_ID
AND uc.DeletedFlag = 0
ORDER BY uc.CreatedDate DESC


DECLARE @TotalElements INT
SELECT @TotalElements = COUNT(1) FROM dbo.#UC_PICK_TO_SCALE

SET NOCOUNT OFF

SELECT
ptc.ORDNUM, 
ptc.SEGNAM, 
ptc.TRNTYP, 
ptc.WHSE_ID, 
ptc.CLIENT_ID,
ptc.SHIP_ID,
ptc.WAVENUM, 
ptc.PRTNUM,
ptc.INV_ATTR_STR1, 
ptc.QTY, 
ptc.INV_ATTR_STR5, 
ptc.STOLOC, 
ptc.UC_CONVEYOR, 
ptc.UC_CONTAINER_FLG, 
ptc.VC_SAMPLE_CLIENT,
ptc.VC_SAMPLE_PROD, 
ptc.UC_SAMP_PL, 
ptc.EXTRL_SRVYR,
ptc.ADNL_TST_REQD,
ISNULL(ptc.OriginPort, '') AS OriginPort,
ISNULL(ptc.DestinationPort, '') AS DestinationPort, 
ISNULL(ptc.Buque, '') AS Buque,
@TotalElements AS TotalElement
FROM dbo.#UC_PICK_TO_SCALE tmptc
INNER JOIN dbo.UC_PICK_TO_SCALE ptc ON tmptc.ORDNUM = ptc.ORDNUM AND ptc.DeletedFlag = 0
ORDER BY ptc.CreatedDate DESC
OFFSET @PageSize * (@PageIndex - 1) ROWS
FETCH NEXT @PageSize ROWS ONLY
