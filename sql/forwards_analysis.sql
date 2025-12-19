-- Premier League Forwards Peak Age Analysis
-- Tool: Google BigQuery
-- Dataset: dauntless-graph-466820-f4.Soccer.forwards
-- Metric: Goals + Assists per 90
-- Purpose: Analyze performance by age and identify peak age patterns

--------------------------------------------------
-- QUERY 1: Average G+A per 90 by Age
-- Purpose: Identify how average attacking output changes with age
--------------------------------------------------
SELECT
  Age,
  ROUND(AVG(`G+A per 90`), 3) AS avg_ga90,
  COUNT(*) AS sample_size
FROM
  `dauntless-graph-466820-f4.Soccer.forwards`
GROUP BY
  Age
ORDER BY
  Age;

--------------------------------------------------
-- QUERY 2: Variability of G+A per 90 by Age
-- Purpose: Measure consistency using standard deviation
--------------------------------------------------
SELECT
  Age,
  ROUND(AVG(`G+A per 90`), 3) AS avg_ga90,
  ROUND(STDDEV_POP(`G+A per 90`), 3) AS sd_ga90,
  COUNT(*) AS sample_size
FROM
  `dauntless-graph-466820-f4.Soccer.forwards`
GROUP BY
  Age
ORDER BY
  Age;

--------------------------------------------------
-- QUERY 3: Performance Range by Age
-- Purpose: Identify best and worst performances within each age group
--------------------------------------------------
SELECT
  Age,
  MIN(`G+A per 90`) AS min_ga90,
  MAX(`G+A per 90`) AS max_ga90
FROM
  `dauntless-graph-466820-f4.Soccer.forwards`
GROUP BY
  Age
ORDER BY
  Age;

--------------------------------------------------
-- QUERY 4: Top 5 Forwards per Age
-- Purpose: Identify elite performers within each age group
--------------------------------------------------
WITH ranked AS (
  SELECT
    Player,
    Squad,
    Season,
    Age,
    Min,
    `G+A per 90`,
    ROW_NUMBER() OVER (
      PARTITION BY Age
      ORDER BY `G+A per 90` DESC
    ) AS rank_within_age
  FROM
    `dauntless-graph-466820-f4.Soccer.forwards`
)
SELECT *
FROM ranked
WHERE rank_within_age <= 5
ORDER BY Age, rank_within_age;
