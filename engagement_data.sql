SELECT 
* 
from dbo.engagement_data

SELECT
	EngagementID,
	ContentID,
	CampaignID,
	ProductID,
	UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
	LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) -1) as Views,
	RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined) ) as Clicks,
	--CHARINDEX('-', ViewsClicksCombined) as num,
	Likes,
	--ViewsClicksCombined,
	FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') as EngagementDate

FROM dbo.engagement_data
WHERE 
	ContentType != 'Newsletter'
	

