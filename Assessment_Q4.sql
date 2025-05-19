-- Assessment_Q4 - Customer Lifetime Value (CLV) Estimation
-- Objective: Estimate CLV for each customer based on tenure and transaction activity.

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Calculate tenure in months since account signup
    GREATEST(PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')), 1) AS tenure_months,

    -- Count total number of savings transactions
    COUNT(s.id) AS total_transactions,

    -- Apply the CLV formula:
    -- (transactions / tenure) * 12 * average profit per transaction
    ROUND(
        (COUNT(s.id) / GREATEST(PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')), 1))
        * 12
        * (0.001 * AVG(s.confirmed_amount) / 100), 2
    ) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.confirmed_amount > 0
GROUP BY u.id, name, u.date_joined
ORDER BY estimated_clv DESC
LIMIT 10;