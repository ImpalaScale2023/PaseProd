-- Query para obtener los IdCompanyBranch
SELECT * FROM dbo.CompanyBranch

-- Query para obtener la lista de impresoras por país y tener el id
SELECT * FROM dbo.Printer where IdCompany = 1 AND IdCompanyBranch = 1

-- Query para validar que registros se van a modificar
SELECT 
* 
FROM dbo.ReWeighing 
WHERE IdCompany = 1 -- No modificar
AND IdCompanyBranch = 1 -- modificar dependiendo el país
AND IdReWeighing = 1 -- comentar si quiere actualizar en masa o poner el ID del registro para actualizar un registro en especifico

RETURN -- QUITAR CUANDO SE VALLA A REALIZAR LA ACTUALIZACIÓN

UPDATE dbo.ReWeighing 
SET IdPrinter = 1 -- actualziar por el id de la impresora que se va ha poner
WHERE IdCompany = 1 -- No modificar
AND IdCompanyBranch = 1 -- modificar dependiendo el país
AND IdReWeighing = 1 -- comentar si quiere actualizar en masa o poner el ID del registro para actualizar un registro en especifico