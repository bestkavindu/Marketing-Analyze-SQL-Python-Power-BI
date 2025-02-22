SELECT
*
from dbo.products


SELECT
	ProductID,
	ProductName,
	Price,

	CASE
		when Price < 50 then 'Low'
		when Price BETWEEN 50 and 200 then 'Medium'
		else 'High'
	END AS PriceCategory

from dbo.products


