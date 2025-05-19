# DataAnalytics-Assessment/
This repository contains my solutions to the SQL assessment provided by Cowrywise for the Data Analyst role. Each query file addresses a specific business problem using structured SQL logic and optimization.


---

## Per-Question Explanations

### **Q1 – High-Value Customers with Multiple Products**

**Objective:** Identify customers with at least one funded savings plan and one funded investment plan, and rank them by total deposits.

**Approach:**
- Joined `users_customuser`, `plans_plan`, and `savings_savingsaccount`.
- Used `COUNT(DISTINCT CASE...)` to count savings and investment plans.
- Aggregated deposits with `SUM(confirmed_amount)` and converted from kobo to Naira.
- Applied `HAVING` to filter customers with both product types.

---

### **Q2 – Transaction Frequency Analysis**

**Objective:** Classify customers into frequency segments based on average transactions per month.

**Approach:**
- Calculated `tenure_months` based on earliest transaction.
- Computed average monthly transactions using `COUNT / tenure`.
- Used `CASE` logic to segment into High (≥10), Medium (3–9), and Low (≤2) frequency.
- Aggregated to get segment counts and average frequency.

---

### **Q3 – Account Inactivity Alert**

**Objective:** Flag accounts (savings or investment) that haven't had inflows for over one year.

**Approach:**
- Joined `plans_plan` and `savings_savingsaccount` using `owner_id`.
- Filtered for funded accounts (`confirmed_amount > 0`) and active types.
- Used `MAX(created_on)` to get the last transaction date.
- Applied `DATEDIFF` and `HAVING` to return inactive accounts.

---

### **Q4 – Customer Lifetime Value (CLV) Estimation**

**Objective:** Estimate CLV using tenure, transaction count, and average transaction profit.

**Approach:**
- Calculated `tenure_months` using `date_joined`.
- Total transactions counted via `COUNT(s.id)`.
- Estimated average profit: `0.1%` of `AVG(confirmed_amount)`.
- Applied formula:  
  `(total_tx / tenure) * 12 * avg_profit`
- Results sorted by highest CLV.

---

## Challenges and Resolutions

| Challenge | Resolution |
|----------|------------|
| MySQL Workbench freezing on large exports | Switched to command line interface imports and used `LIMIT` for previews |
| Output formatting & export lags | Used smaller result sets and gear icon export for CSVs |

---

## Notes

- All currency values are converted from **kobo to Naira** by dividing by 100.
- Every `.sql` file is:
  - Single-query
  - Formatted cleanly
  - Commented for clarity

---


