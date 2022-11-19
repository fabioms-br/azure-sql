DECLARE @valor numeric(18,2) = 5.34

SELECT @valor AS Original
       ,REPLACE(@valor,'.',',') AS Substituir
	   ,FORMAT(@valor, 'N', 'pt-BR') AS Numerico
	   ,FORMAT(@valor, 'C', 'pt-BR') AS Moeda;