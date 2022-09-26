/* 1. Criar Tabela Grafo de Palavras */

-- Nodes Table
CREATE TABLE Palavras (
  ID INTEGER PRIMARY KEY,
  nome VARCHAR(100),
  tipo VARCHAR(25), -- Armazenar o tipo da palavra (noum, verb)
) AS NODE

-- Edges Table

CREATE TABLE LinkPara AS EDGE;

/* 2. Inserir Registros NODE */

INSERT INTO Palavras (ID, nome, tipo)
	VALUES (1, 'chart', 'noum')
		  ,(2, 'plan', 'verb')
		  ,(3, 'graph', 'verb')
		  ,(4, 'map', 'noum')
		  ,(5, 'diagram', 'verb')
		  ,(6, 'plot', 'verb')
		  ,(7, 'game', 'noum')
		  ,(8, 'story', 'noum')

/* 3. Inserir Registros EDGE */

-- Palavras associadas a palavra 'chart'
-- Origem = 1 Destino = 2,3,4
INSERT INTO LinkPara
	VALUES ( (SELECT $node_id FROM Palavras WHERE ID = 1), (SELECT $node_id FROM Palavras WHERE ID = 2)  )
	      ,( (SELECT $node_id FROM Palavras WHERE ID = 1), (SELECT $node_id FROM Palavras WHERE ID = 3)  )
		  ,( (SELECT $node_id FROM Palavras WHERE ID = 1), (SELECT $node_id FROM Palavras WHERE ID = 4)  )

-- Palavras associadas a palavra 'graph'
-- Origem = 3 Destino = 1,5,6
INSERT INTO LinkPara
	VALUES ( (SELECT $node_id FROM Palavras WHERE ID = 3), (SELECT $node_id FROM Palavras WHERE ID = 1)  )
	      ,( (SELECT $node_id FROM Palavras WHERE ID = 3), (SELECT $node_id FROM Palavras WHERE ID = 5)  )
		  ,( (SELECT $node_id FROM Palavras WHERE ID = 3), (SELECT $node_id FROM Palavras WHERE ID = 6)  )

-- Palavras associadas a palavra 'plot'
-- Origem = 6 Destino = 1,2,5,7,8
INSERT INTO LinkPara
	VALUES ( (SELECT $node_id FROM Palavras WHERE ID = 6), (SELECT $node_id FROM Palavras WHERE ID = 1)  )
	      ,( (SELECT $node_id FROM Palavras WHERE ID = 6), (SELECT $node_id FROM Palavras WHERE ID = 2)  )
		  ,( (SELECT $node_id FROM Palavras WHERE ID = 6), (SELECT $node_id FROM Palavras WHERE ID = 5)  )
		  ,( (SELECT $node_id FROM Palavras WHERE ID = 6), (SELECT $node_id FROM Palavras WHERE ID = 7)  )
		  ,( (SELECT $node_id FROM Palavras WHERE ID = 6), (SELECT $node_id FROM Palavras WHERE ID = 8)  )



/*4. Consultar e Filtrar Registros */

SELECT origem.nome, destino.nome,
       origem.tipo, destino.tipo
FROM Palavras AS origem,
	 LinkPara,
	 Palavras AS destino
WHERE MATCH(origem-(LinkPara)->destino)
AND origem.tipo = 'verb' and destino.tipo = 'noum'


/* 5. Criar Exibição */

CREATE OR ALTER VIEW PalavrasAssociadas
AS

SELECT origem.nome AS [origem], 
       destino.nome AS [destino],
       CONCAT(origem.tipo, '-', destino.tipo) AS LinkPara
FROM Palavras AS origem,
	 LinkPara,
	 Palavras AS destino
WHERE MATCH(origem-(LinkPara)->destino)

