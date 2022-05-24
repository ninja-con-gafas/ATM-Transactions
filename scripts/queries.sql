-- 1. Top 10 ATMs where most transactions are in the ’inactive’ state

SELECT atm.dim_atm.atm_number, atm.dim_location.location, COUNT (atm.fact_atm_trans.atm_status) AS inactive_transactions

FROM atm.fact_atm_trans

JOIN atm.dim_atm ON (atm.dim_atm.atm_id = atm.fact_atm_trans.atm_id)
JOIN atm.dim_location ON (atm.dim_location.location_id = atm.dim_atm.atm_location_id)

WHERE atm.fact_atm_trans.atm_status = 'Inactive'

GROUP BY atm.dim_atm.atm_number, atm.dim_location.location

ORDER BY inactive_transactions DESC 

LIMIT 10;

-- 2. Number of ATM failures corresponding to the different weather conditions recorded at the time of the transactions

SELECT atm.fact_atm_trans.weather_main, COUNT (atm.fact_atm_trans.atm_status) AS number_of_failures

FROM atm.fact_atm_trans

WHERE atm.fact_atm_trans.weather_main IS NOT NULL AND LENGTH (atm.fact_atm_trans.weather_main) > 0

GROUP BY atm.fact_atm_trans.weather_main

ORDER BY number_of_failures DESC;

-- 3. Top 10 ATMs with the most number of transactions throughout the year

SELECT atm.dim_atm.atm_number, atm.dim_location.location, COUNT (atm.fact_atm_trans.trans_id) AS number_of_transactions

FROM atm.fact_atm_trans

JOIN atm.dim_atm ON (atm.dim_atm.atm_id = atm.fact_atm_trans.atm_id)
JOIN atm.dim_location ON (atm.dim_location.location_id = atm.dim_atm.atm_location_id)

GROUP BY atm.dim_atm.atm_number, atm.dim_location.location

ORDER BY number_of_transactions DESC

LIMIT 10;

-- 4. Number of overall ATM transactions going inactive per month for each month

SELECT atm.dim_date.month, COUNT (atm.fact_atm_trans.trans_id) AS inactive_transactions

FROM atm.fact_atm_trans

JOIN atm.dim_date ON (atm.dim_date.date_id = atm.fact_atm_trans.date_id)

WHERE atm.fact_atm_trans.atm_status = 'Inactive'

GROUP BY atm.dim_date.month

ORDER BY TO_DATE (atm.dim_date.month, 'Month');

-- 5. Top 10 ATMs with the highest total amount withdrawn throughout the year 

SELECT atm.dim_atm.atm_number, atm.dim_location.location, SUM (atm.fact_atm_trans.transaction_amount) AS withdrawal_amount

FROM atm.fact_atm_trans

JOIN atm.dim_atm ON (atm.dim_atm.atm_id = atm.fact_atm_trans.atm_id)
JOIN atm.dim_location ON (atm.dim_location.location_id = atm.dim_atm.atm_location_id)

WHERE atm.fact_atm_trans.service = 'Withdrawal'

GROUP BY atm.fact_atm_trans.service, atm.dim_atm.atm_number, atm.dim_location.location

ORDER BY withdrawal_amount DESC

LIMIT 10;

-- 6. Number of failed ATM transactions across various card types

SELECT atm.dim_card_type.card_type, COUNT (atm.fact_atm_trans.trans_id) AS failed_transactions

FROM atm.fact_atm_trans

JOIN atm.dim_card_type ON (atm.dim_card_type.card_type_id = atm.fact_atm_trans.card_type_id)

WHERE atm.fact_atm_trans.atm_status = 'Inactive'

GROUP BY atm.dim_card_type.card_type

ORDER BY failed_transactions DESC;

/** 
  7. Top 10 records with the number of transactions ordered by the ATM_number, ATM_manufacturer, location, weekend_flag
     and then total_transaction_count, on weekdays and on weekends throughout the year 
*/

SELECT atm.dim_atm.atm_number, atm.dim_atm.atm_manufacturer, atm.dim_location.location, COUNT (atm.fact_atm_trans.trans_id) AS total_transaction_count,

CASE
	WHEN EXTRACT(DOW FROM atm.dim_date.full_date_time::TIMESTAMP) IN (0, 6) THEN 'Weekends'
	ELSE 'Weekdays'
END AS weekend_flag

FROM atm.fact_atm_trans

JOIN atm.dim_atm ON (atm.dim_atm.atm_id = atm.fact_atm_trans.atm_id)
JOIN atm.dim_location ON (atm.dim_location.location_id = atm.dim_atm.atm_location_id)
JOIN atm.dim_date ON (atm.dim_date.date_id = atm.fact_atm_trans.date_id)

GROUP BY atm.dim_atm.atm_number, atm.dim_atm.atm_manufacturer, atm.dim_location.location, weekend_flag

ORDER BY atm.dim_atm.atm_number, atm.dim_atm.atm_manufacturer, atm.dim_location.location, weekend_flag, total_transaction_count DESC

LIMIT 10;

-- 8. Most active day in each ATMs from location "Vejgaard"

SELECT atm_number, location, weekday, transactions

FROM
(
  
  SELECT *, MAX (transactions) OVER (PARTITION BY atm_number) AS max_transactions
  
  FROM
  (
    
    SELECT atm.dim_atm.atm_number AS atm_number, atm.dim_location.location AS location, atm.dim_date.weekday AS weekday, COUNT (atm.fact_atm_trans.trans_id) AS transactions

    FROM atm.fact_atm_trans

    JOIN atm.dim_atm ON (atm.dim_atm.atm_id = atm.fact_atm_trans.atm_id)
    JOIN atm.dim_location ON (atm.dim_location.location_id = atm.dim_atm.atm_location_id)
    JOIN atm.dim_date ON (atm.dim_date.date_id = atm.fact_atm_trans.date_id)

    WHERE atm.dim_location.location = 'Vejgaard'

    GROUP BY atm.dim_atm.atm_number, atm.dim_location.location, atm.dim_date.weekday

    ORDER BY transactions DESC
    
  ) AS SUBQUERY
  
) AS SUBQUERY

WHERE transactions = max_transactions;
