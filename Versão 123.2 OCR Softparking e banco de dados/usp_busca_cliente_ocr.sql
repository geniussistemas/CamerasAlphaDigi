ALTER procedure [dbo].[usp_busca_cliente_ocr]
(
@Placa varchar(7),
@cliente varchar (10) output,
@status varchar(1) output
)
as
DECLARE @Tipo_cliente varchar(1)
set @status ='1'


SET @Cliente = (select top(1) cliente from cliente_placa where Cliente_Placa = @Placa) 

if not exists (select top(1) cliente from cliente_placa where Cliente_Placa = @Placa)
begin
  SET @cliente = '0' 
  SET @status = '1'
  RETURN
end

SET @Tipo_cliente = (select Tipo_VENCIMENTO from cliente where Cliente = @cliente)


if (@Tipo_cliente = 2) or (@Tipo_cliente  = 3)
begin

  SET @status = '0'
  RETURN

end


