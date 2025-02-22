

WITH DuplicateRecords AS (
	SELECT 
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		Stage,
		Action,
		Duration,
		ROW_NUMBER() OVER(
			PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
			ORDER BY JourneyID
		) As row_num

	FROM dbo.customer_journey
)

--SELECT * FROM DuplicateRecords
--WHERE row_num > 1
--ORDER BY JourneyID

SELECT
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	avg_duration,
	Action,
	COALESCE(Duration, avg_duration) as Duration

FROM
	(
		SELECT
			JourneyID,
			CustomerID,
			ProductID,
			VisitDate,
			UPPER(Stage) as Stage,
			Action,
			Duration,
			AVG(Duration) OVER (PARTITION by VisitDate) as avg_duration,
			
			ROW_NUMBER() OVER (
				PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
				ORDER BY JourneyID
			) as row_num

		FROM
			dbo.customer_journey
	) AS subquery
where row_num = 1
