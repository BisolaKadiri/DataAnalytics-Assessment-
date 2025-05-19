-- Assessment_Q3 - Account Inactivity Alert
-- Objective: Identify active savings or investment accounts with no inflow transactions in the last 365 days.

SELECT
    p.id AS plan_id,
    p.owner_id,
    -- Determine plan type based on flags
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,

    -- Find the last transaction date from savings activity
    MAX(s.created_on) AS last_transaction_date,

    -- Calculate days since last transaction
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days
FROM plans_plan p
JOIN savings_savingsaccount s ON p.owner_id = s.owner_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)
  AND s.confirmed_amount > 0
GROUP BY p.id, p.owner_id, type
-- Only include accounts with inactivity > 365 days
HAVING DATEDIFF(CURDATE(), MAX(s.created_on)) > 365;
