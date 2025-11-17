-- =====================================================================
-- Script: 04_create_account_budget_monitor_role.sql
-- Purpose: Create role for non-ACCOUNTADMIN users to view account budget
-- Description: This role allows users to view the account budget 
--              without the ability to edit it
-- =====================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE BUDGET_DB;
USE SCHEMA BUDGET_SCHEMA;

-- Create a role named account_budget_monitor to view the account budget
CREATE ROLE IF NOT EXISTS ACCOUNT_BUDGET_MONITOR;

-- Grant the SNOWFLAKE.BUDGET_VIEWER application role
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE ACCOUNT_BUDGET_MONITOR;

-- Grant imported privileges on SNOWFLAKE database for cost management access
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE ACCOUNT_BUDGET_MONITOR;

-- Replace <username> with your own username
-- You need to use your own username to pass the DORA grading check later
GRANT ROLE ACCOUNT_BUDGET_MONITOR TO USER <username>;

-- Grant access to the warehouse used for running cost management
-- This is the warehouse that was created earlier for running cost management queries
GRANT USAGE ON WAREHOUSE SNOWSIGHT_WH TO ROLE ACCOUNT_BUDGET_MONITOR;

-- Verify role was created successfully
SHOW ROLES LIKE 'ACCOUNT_BUDGET_MONITOR';

-- Note: Users with this role can:
-- - View the account budget
-- - Cannot edit the account budget
-- - Cannot view or create custom budgets

-- IMPORTANT TESTING INSTRUCTIONS:
-- After creating this role, TEST IT by:
-- 1. Switching to ACCOUNT_BUDGET_MONITOR role in Snowsight (not ACCOUNTADMIN)
-- 2. Go to Admin → Cost Management → Budgets
-- 3. Verify you CANNOT see the three-dot menu (⋮) next to account budget
-- 4. Verify you CANNOT click any edit buttons
-- 5. If you CAN edit, you may still be in ACCOUNTADMIN role - check top-right corner

-- Reference: https://docs.snowflake.com/en/user-guide/budgets/monitor

