-- Assessment_Q2 - Transaction Frequency Analysis
-- Objective: Categorize customers based on their average monthly transaction frequency using the total number of transactions and the time since their first transaction.

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT
        u.id AS customer_id,
        COUNT(s.id) AS total_transactions,

        -- Calculate tenure in months since the first recorded transaction
        GREATEST(
            PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(MIN(s.created_on), '%Y%m')),
            1
        ) AS tenure_months,

        -- Compute average transactions per month per customer
        COUNT(s.id) / GREATEST(
            PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(MIN(s.created_on), '%Y%m')),
            1
        ) AS avg_tx_per_month,

        -- Categorize frequency based on average monthly transactions
        CASE
            WHEN COUNT(s.id) / GREATEST(PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(MIN(s.created_on), '%Y%m')), 1) >= 10 THEN 'High Frequency'
            WHEN COUNT(s.id) / GREATEST(PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(MIN(s.created_on), '%Y%m')), 1) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY u.id
) AS sub
GROUP BY frequency_category;