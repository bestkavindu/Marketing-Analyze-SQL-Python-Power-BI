SELECT 
*
FROM dbo.customer_reviews

SELECT
	ReviewID,
	CustomerID,
	ProductID,
	ReviewDate,
	Rating,
	REPLACE(ReviewText,'  ',' ') as ReviewText

--INTO customer_reviews_updated

FROM 
	dbo.customer_reviews
