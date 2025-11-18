# Phase 2: Setting Up Budgets

**Estimated Time:** 20-25 minutes

## Overview
In this phase, you'll set up both account-level and custom budgets to monitor and control spending across your Snowflake account.

---

## Step 1: Enable Account-Level Budget

### 1.1 Understanding Account Budgets
The account-level budget monitors **all credit consumption** across your entire Snowflake account. This provides a high-level view of your total spending and helps you stay within your monthly budget.

### 1.2 Set Up Account Budget via Snowsight
1. Navigate to **Admin** → **Cost Management** → **Budgets**

<img src="/images/AccountBudget.png" width="70%">

2. Click on **Set Up Account Budget** button
   - **Note:** If the account budget is already set up, you'll see a **+** button and a **⋮** (three dots) menu instead

3. In the setup dialog:
   - **Target Spending Limit:** Enter your monthly budget in dollars (e.g., 1000)
   - **Email Recipients:** Add email addresses for daily notifications

4. Click **Save** to activate the account budget

<img src="/images/AccountBudgetSetup.png" width="70%">

### 1.3 View the Budget Trendline
Once the account budget is set up, you'll see:
- **Current spend** vs. **projected spend**
- **Remaining budget** for the month
- **Daily burn rate** visualization
- **Forecast** showing if you're on track to exceed the budget

### 1.4 Understanding Email Notifications
When your usage exceeds projected limits, you'll receive daily email notifications containing:
- Current spend vs. budget
- Percentage of budget consumed
- Estimated end-of-month spend
- Recommendations for cost optimization

Here is an example of what the daily notification email looks like when the usage exceeds the projected limits
<img src="/images/emailexample.png" width="70%">
---

## Step 2: Create Database for Custom Budgets

### 2.1 Why a Dedicated Database?
Custom budgets are stored as objects within a Snowflake database. Creating a dedicated database helps organize these budget objects separately from your data.

### 2.2 Create the Budget Database
1. Navigate to **scripts/03_create_budget_database.sql**
2. Run the script to create:
   - Database: `BUDGET_DB`
   - Schema: `BUDGET_SCHEMA`

3. Verify creation:
```sql
SHOW DATABASES LIKE 'BUDGET_DB';
SHOW SCHEMAS IN DATABASE BUDGET_DB;
```

### 2.3 Refresh Snowsight (if needed)
If `BUDGET_DB.BUDGET_SCHEMA` doesn't appear in dropdown menus:
1. Click the refresh icon next to the database selector
2. If that doesn't work, refresh the entire Snowsight page (F5 or Cmd+R)

---

## Step 3: Create First Custom Budget

### 3.1 Understanding Custom Budgets
Custom budgets allow you to monitor spending for **specific resources**:
- Individual warehouses
- Groups of warehouses
- Specific databases
- Combinations of resources

This is useful for:
- Department-specific cost tracking
- Project-based budget monitoring
- Environment-specific limits (dev, staging, prod)

### 3.2 Create CUSTOM_BUDGET_1 via Snowsight
1. Navigate to **Admin** → **Cost Management** → **Budgets**
2. Click the **+ (plus)** button to add a custom budget
3. In the creation dialog:
   - **Name:** `CUSTOM_BUDGET_1`
   - **Database:** Select `BUDGET_DB`
   - **Schema:** Select `BUDGET_SCHEMA`
   - **Budget Amount:** Enter a spending limit (e.g., 500)
4. Click **+ Resources** to add resources to monitor:
   - Select **at least two warehouses** from your account
   - Example warehouses: `COMPUTE_WH`, `CAPSTONE_AUDIT_WH`
   - You can also add specific databases

5. Click **Create Budget**

<img src="/images/custombudget1.png" width="70%">


### 3.3 View Custom Budget Details
1. Scroll down on the Budgets page to see custom budget tiles
   - If you don't see **Budgets**, click **Resources** → **Budgets** in the menu
2. Click on the **CUSTOM_BUDGET_1** tile
3. Explore the details:
   - Resource-specific consumption breakdown
   - Budget utilization percentage
   - Credit usage trends
   - List of linked resources

---

## Step 4: Create Second Custom Budget

### 4.1 Create CUSTOM_BUDGET_2
1. Click the **+ (plus)** button again
2. Create another custom budget with these settings:
   - **Name:** `CUSTOM_BUDGET_2`
   - **Database:** `BUDGET_DB`
   - **Schema:** `BUDGET_SCHEMA`
   - **Budget Amount:** Enter a different limit (e.g., 300)

3. Add resources:
   - Select **one warehouse** that was also added to CUSTOM_BUDGET_1
   - Example: `CAPSTONE_AUDIT_WH`

### 4.2 Understanding Resource Movement
**Important Behavior:** When you add a resource to a new budget that previously belonged to another budget:
- The resource **automatically moves** from the original budget to the new budget
- **No error or notification** is displayed
- The change happens silently

### 4.3 Verify Resource Assignment
After creating CUSTOM_BUDGET_2, check CUSTOM_BUDGET_1:
1. Click on the **CUSTOM_BUDGET_1** tile
2. Verify that the shared warehouse (e.g., `CAPSTONE_AUDIT_WH`) is **no longer listed**
3. The warehouse has moved to CUSTOM_BUDGET_2

You can also verify programmatically using **scripts/06_view_budget_linked_resources.sql**

---

## Step 5: View Linked Resources Programmatically

### 5.1 Verify Budgets Exist First
Before calling the stored procedures, verify your custom budgets were created.

**Method 1: Check in Snowsight UI**
- Navigate to Admin → Cost Management → Budgets
- Scroll down to see your custom budget tiles
- If you see CUSTOM_BUDGET_1 and CUSTOM_BUDGET_2, proceed to 5.2

**Method 2: Check via SQL (if UI method above shows budgets exist)**
```sql
USE ROLE ACCOUNTADMIN;
USE DATABASE BUDGET_DB;
USE SCHEMA BUDGET_SCHEMA;

-- When budgets are created, they automatically create stored procedures
-- Check if these procedures exist
SHOW PROCEDURES IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- Look for procedures named like: "CUSTOM_BUDGET_1!GET_LINKED_RESOURCES"
-- If you see them, the budgets exist
```

**If no budgets appear:** Go back to Step 3 and create them via Snowsight UI first.

### 5.2 Run the SQL Command
Navigate to [06_view_budget_linked_resources.sql](scripts/06_view_budget_linked_resources.sql) and run:

```sql
-- View resources for each budget
CALL BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!GET_LINKED_RESOURCES();
CALL BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_2!GET_LINKED_RESOURCES();
```

**Note:** If you get an error "Unknown user-defined function", it means the budget hasn't been created via Snowsight UI yet. Go back to Step 3 and create the budgets first.

### 5.3 Interpret Results
The stored procedure returns:
- Resource type (WAREHOUSE or DATABASE)
- Resource name
- When it was added to the budget

This helps you:
- Audit which resources belong to which budget
- Identify if resources have moved between budgets
- Ensure proper cost allocation

---

## Checkpoint ✓

Before proceeding to Phase 3, verify:
- [ ] Account budget is enabled with email notifications configured
- [ ] BUDGET_DB database and BUDGET_SCHEMA schema exist
- [ ] CUSTOM_BUDGET_1 is created with at least two warehouses
- [ ] CUSTOM_BUDGET_2 is created with one warehouse from CUSTOM_BUDGET_1
- [ ] You understand that resources can only belong to one custom budget at a time
- [ ] You can view linked resources using SQL stored procedures

---

## Troubleshooting

**Issue:** Can't create custom budget (permission denied)  
**Solution:** Ensure you're using the ACCOUNTADMIN role. Custom budgets can only be created by ACCOUNTADMIN.

**Issue:** BUDGET_DB.BUDGET_SCHEMA doesn't appear in dropdown  
**Solution:** 
1. Click the refresh icon in the database selector
2. Wait 10-15 seconds for the schema cache to refresh
3. If still not visible, refresh the entire Snowsight page

**Issue:** Resources don't appear to move between budgets in UI  
**Solution:** The UI may cache budget information. Run the SQL command `GET_LINKED_RESOURCES()` to see the actual state.

**Issue:** Can't add resources to custom budget  
**Solution:** Ensure the resources (warehouses/databases) actually exist and you have visibility to them with your current role.

---

## Next Steps
Proceed to [Phase 3: Access Control for Budgets](phase3_access_control_for_budgets.md)

