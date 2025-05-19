-- Assessment_Q1 - High-Value Customers with Multiple Products
-- Objective: Identify customers who have both at least one funded savings plan and one funded investment plan.
-- Output includes: owner_id, name, number of each plan type, and total deposits.

USE adashi_staging;

SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Count number of distinct savings plans
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,

    -- Count number of distinct investment plans
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

    -- Calculate total deposits (in Naira, converting from kobo)
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits

FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.confirmed_amount > 0
GROUP BY u.id, name

-- Only include customers with at least one of each plan type
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;
