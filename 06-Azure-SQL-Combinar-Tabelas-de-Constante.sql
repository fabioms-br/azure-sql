SELECT B.ProductIndex, A.ProductName, 
	A.ProductPrice, B.ProductQuant FROM
(VALUES 
	(0,'Product A', 12.5),
	(1,'Product B', 5.25),
	(2,'Product C', 25)
) A(ProductIndex, ProductName, ProductPrice) 

RIGHT JOIN

(SELECT B.ProductIndex, B.ProductQuant FROM
(VALUES
	(0, 1200),
	(1, 600),
	(3, 800)
) B(ProductIndex, ProductQuant)) AS B
ON A.ProductIndex = B.ProductIndex