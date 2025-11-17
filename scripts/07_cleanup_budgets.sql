-- =====================================================================
-- Script: 07_cleanup_budgets.sql
-- Purpose: Clean up custom budgets after completing the lab
-- Description: This script drops custom budgets created during the lab.
--              Note: The SNOWSIGHT_WH warehouse, account budget, and
--              roles will be retained for future use.
-- =====================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SNOWSIGHT_WH;
USE DATABASE BUDGET_DB;
USE SCHEMA BUDGET_SCHEMA;

-- Drop CUSTOM_BUDGET_2 if it exists
DROP SNOWFLAKE.CORE.BUDGET IF EXISTS BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_2;

-- Drop CUSTOM_BUDGET_1 if it exists
DROP SNOWFLAKE.CORE.BUDGET IF EXISTS BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1;

-- Verify budgets have been dropped
-- You can also verify this in the Snowsight Cost Management interface

-- Note: Items NOT cleaned up (intentionally retained):
-- - SNOWSIGHT_WH warehouse (for future cost management queries)
-- - Account budget (continues to monitor account-level spending)
-- - ACCOUNT_BUDGET_MONITOR role (for non-admin users to view account budget)
-- - CUSTOM_BUDGET_MONITOR role (can be used for future custom budgets)
-- - BUDGET_DB database and schema (for future budget management)

-- Optional: To remove the database and roles completely, uncomment below:
DROP DATABASE IF EXISTS BUDGET_DB;
DROP ROLE IF EXISTS ACCOUNT_BUDGET_MONITOR;
DROP ROLE IF EXISTS CUSTOM_BUDGET_MONITOR;
DROP WAREHOUSE IF EXISTS SNOWSIGHT_WH;

