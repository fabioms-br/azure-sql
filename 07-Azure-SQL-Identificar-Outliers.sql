WITH  RANGE_DATA  AS    
(

    SELECT [Data], [Moeda], [Taxa_Venda]
    FROM [SANDBOX].[dbo].API_BCB_COTACOES
    --WHERE YEAR([Data]) = '2015' 

),
QUARTILE_VALUES AS
(

    -- Calcular o IQR = Q3 - Q1
    SELECT *, IQR = (Q3 - Q1)
    FROM (
        SELECT DISTINCT [Moeda],
            -- Ordenar os dados do menor valor ao maior valor 
            -- Identificar o primeiro quartil (Q1), a mediana e o terceiro quartil (Q3).
             PERCENTILE_CONT(0.25) WITHIN GROUP(ORDER BY [Taxa_Venda]) OVER(PARTITION BY [Moeda]) As Q1,
             PERCENTILE_CONT(0.50) WITHIN GROUP(ORDER BY [Taxa_Venda]) OVER(PARTITION BY [Moeda]) As Median,
             PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY [Taxa_Venda]) OVER(PARTITION BY [Moeda]) As Q3
        FROM RANGE_DATA
    ) AS R1


),
OUTLIER_VALUES  AS
(

    SELECT *,
        -- Calcular limite superior = Q3 + (1.5 * IQR)
        UPPER_FENCE = (Q3 + (1.5*IQR)),
        -- Calcular limite inferior = Q1 - (1.5 * IQR)
        LOWER_FENCE = (Q1 - (1.5*IQR))
    FROM QUARTILE_VALUES

)


/* Whisker Type */
SELECT [Moeda], MAX([Taxa_Venda]) AS 'Upper Whisker', MIN([Taxa_Venda]) AS 'Lower Whisker'
FROM (


    SELECT [Data], [Moeda], [Taxa_Venda], 
        (CASE 
                WHEN [Taxa_Venda] < t2.LOWER_FENCE THEN 'Lower Outlier'
                WHEN [Taxa_Venda] > t2.UPPER_FENCE THEN 'Upper Outlier'
                ELSE NULL
        END) AS OUTLIER_STATUS
    FROM RANGE_DATA t1
    CROSS APPLY (

        SELECT LOWER_FENCE, UPPER_FENCE
        FROM OUTLIER_VALUES AS rs
        WHERE rs.[Moeda] = t1.[Moeda]

    ) AS t2


) RS
WHERE OUTLIER_STATUS IS NULL
GROUP BY [Moeda], OUTLIER_STATUS



