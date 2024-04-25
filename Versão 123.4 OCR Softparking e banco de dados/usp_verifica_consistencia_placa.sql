alter PROCEDURE [dbo].[USP_VERIFICA_CONSISTENCIA_PLACA]
(
@Movimento varchar(6),
@Placa varchar(7),
@Entrada datetime,
@Resultado char (1) OUTPUT
)
AS

declare @PlacaGravada varchar(7),
@MovimentoEntrada varchar(6),
@i integer,
@AuxPlacaGravada varchar(1),
@AuxPlaca varchar (1),
@Acertos integer

SET @PlacaGravada = (Select top(1) Cliente_Placa from movimento_Diario where movimento = @Movimento and Entrada = @Entrada) 
SET @MovimentoEntrada = (Select top(1) Movimento from movimento_Diario where cliente_placa = @Placa and Entrada = @Entrada) 

if @Placa = '' 
Begin
SET @Resultado = '1'
insert into Leitura_Placas_OCR ([MovimentoEntrada], [DataEntrada],	[DataVerificacao],	[PlacaEntrada] ,[MovimentoSaida] ,
	[PlacaSaida] ,[Correspondencia] )values
	(@Movimento, @Entrada,	getdate(),	@PlacaGravada ,@Movimento ,
	@Placa ,'')
RETURN
End



if @PlacaGravada = ''
Begin
SET @Resultado = '1'
   insert into Leitura_Placas_OCR ([MovimentoEntrada], [DataEntrada],	[DataVerificacao],	[PlacaEntrada] ,[MovimentoSaida] ,
	[PlacaSaida] ,[Correspondencia] )values
	(@Movimento, @Entrada,	getdate(),	@PlacaGravada ,@Movimento ,
	@Placa ,'')



RETURN
End


if @Placa = @PlacaGravada
begin
set @Resultado = '1'
       insert into Leitura_Placas_OCR ([MovimentoEntrada], [DataEntrada],	[DataVerificacao],	[PlacaEntrada] ,[MovimentoSaida] ,
	[PlacaSaida] ,[Correspondencia] )values
	(@Movimento, @Entrada,	getdate(),	@PlacaGravada ,@Movimento ,
	@Placa ,'1')


end
else 
begin
    SEt @i = 1
    SET @Acertos = 0
    while @i < 8 
    begin
       SET @AuxPlacaGravada = (SUBSTRING(@PlacaGravada,@i,1))
       SET @AuxPlaca = (SUBSTRING(@Placa,@i,1))
    
       if @AuxPlacaGravada = @AuxPlaca
       Begin
         SET @Acertos = @Acertos +1
             
       End
       
       set @i = @i+1
    end

    if @Acertos >=6 -- aqui controla quantas letras da placa que não bate com a enrada
    --vai leberar o acesso mesmo assim.
    Begin
    insert into Leitura_Placas_OCR ([MovimentoEntrada], [DataEntrada],	[DataVerificacao],	[PlacaEntrada] ,[MovimentoSaida] ,
	[PlacaSaida] ,[Correspondencia] )values
	(@Movimento, @Entrada,	getdate(),	@PlacaGravada ,@Movimento ,
	@Placa ,'1')
    
     set @resultado = '1'
     
     return
    
    End

    insert into Leitura_Placas_OCR ([MovimentoEntrada], [DataEntrada],	[DataVerificacao],	[PlacaEntrada] ,[MovimentoSaida] ,
	[PlacaSaida] ,[Correspondencia] )values
	(@Movimento, @Entrada,	getdate(),	@PlacaGravada ,@Movimento ,
	@Placa ,'0')


set @resultado = '0'
end
GO