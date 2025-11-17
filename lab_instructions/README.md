## 🚀 Lab Execution Guide

### Script Execution Order

Execute the SQL scripts in the following order. Each script corresponds to a specific phase of the lab:

#### **Phase 1: Setup and Prerequisites** (15-20 min)

**📘 Detailed Instructions:** [Phase 1: Setup and Prerequisites](lab_instructions/phase1_setup_and_prerequisites.md)

1. **01_setup_email_notifications.sql**
   - **Purpose:** Configure email address for budget notifications
   - **What it does:** Sets and verifies email for the ACCOUNTADMIN user
   - **Important:** Replace `<username>` and `<email@address>` with actual values
   - **After running:** Check email for verification link and click to verify

2. **02_create_snowsight_warehouse.sql**
   - **Purpose:** Create dedicated warehouse for Cost Management queries
   - **What it does:** Creates `SNOWSIGHT_WH` with X-Small size and 60-second auto-suspend
   - **After running:** Select this warehouse in the Cost Management interface

---

#### **Phase 2: Setting Up Budgets** (20-25 min)
**📘 Detailed Instructions:** [Phase 2: Setting Up Budgets](lab_instructions/phase2_setting_up_budgets.md)

3. **03_create_budget_database.sql**
   - **Purpose:** Create database for storing custom budget objects
   - **What it does:** Creates `BUDGET_DB` database and `BUDGET_SCHEMA` schema
   - **After running:** Refresh Snowsight if the database doesn't appear in dropdowns

**Manual Step (Snowsight UI):**
- **Enable Account Budget:** 
  - Navigate to Admin → Cost Management → Budgets
  - Click "Set Up Account Budget"
  - Set spending limit and configure email notifications
  - Save and verify budget trendline appears

**Manual Step (Snowsight UI):**
- **Create CUSTOM_BUDGET_1:**
  - Click the "+" button in Budgets section
  - Name: `CUSTOM_BUDGET_1`
  - Database: `BUDGET_DB`, Schema: `BUDGET_SCHEMA`
  - Add at least 2 warehouses
  - Set budget amount and create

**Manual Step (Snowsight UI):**
- **Create CUSTOM_BUDGET_2:**
  - Click the "+" button again
  - Name: `CUSTOM_BUDGET_2`
  - Database: `BUDGET_DB`, Schema: `BUDGET_SCHEMA`
  - Add 1 warehouse (use one from CUSTOM_BUDGET_1 to see resource movement behavior)
  - Set budget amount and create

---

#### **Phase 3: Access Control for Budgets** (20-25 min)
**📘 Detailed Instructions:** [Phase 3: Access Control for Budgets](lab_instructions/phase3_access_control_for_budgets.md)

4. **04_create_account_budget_monitor_role.sql**
   - **Purpose:** Create role for viewing account budget (read-only)
   - **What it does:** Creates `ACCOUNT_BUDGET_MONITOR` role and grants budget viewer privileges
   - **Important:** Replace `<username>` with your actual username (required for DORA grading)
   - **After running:** Switch to this role in Snowsight and verify you can see account budget but not custom budgets

5. **05_create_custom_budget_monitor_role.sql**
   - **Purpose:** Create role for viewing specific custom budgets (read-only)
   - **What it does:** Creates `CUSTOM_BUDGET_MONITOR` role and grants access to `CUSTOM_BUDGET_1`
   - **Important:** Replace `<username>` with your actual username
   - **After running:** Switch to this role and verify you can see CUSTOM_BUDGET_1 but not account budget

6. **06_view_budget_linked_resources.sql**
   - **Purpose:** Display resources assigned to each custom budget
   - **What it does:** Calls stored procedures to list warehouses/databases in each budget
   - **Use case:** Verify which resources belong to which budget, especially after moving resources between budgets
   - **After running:** Review output to confirm resource assignments

---