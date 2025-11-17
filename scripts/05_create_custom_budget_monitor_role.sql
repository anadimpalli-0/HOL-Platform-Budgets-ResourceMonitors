-- =====================================================================
-- Script: 05_create_custom_budget_monitor_role.sql
-- Purpose: Create role for non-ACCOUNTADMIN users to view custom budgets
-- Description: This role allows users to view specific custom budgets
--              without the ability to create or edit them
-- =====================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE BUDGET_DB;
USE SCHEMA BUDGET_SCHEMA;

-- Create role custom_budget_monitor to view credit usage for custom budgets
CREATE ROLE IF NOT EXISTS CUSTOM_BUDGET_MONITOR;

-- Grant access to database, schema, and warehouse
GRANT USAGE ON DATABASE BUDGET_DB TO ROLE CUSTOM_BUDGET_MONITOR;

GRANT USAGE ON SCHEMA BUDGET_DB.BUDGET_SCHEMA TO ROLE CUSTOM_BUDGET_MONITOR;

GRANT USAGE ON WAREHOUSE SNOWSIGHT_WH TO ROLE CUSTOM_BUDGET_MONITOR;

-- Grant access to a specific custom budget (CUSTOM_BUDGET_1)
-- Note: This assumes CUSTOM_BUDGET_1 has been created in Snowsight
GRANT SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!VIEWER
  TO ROLE CUSTOM_BUDGET_MONITOR;

-- Grant imported privileges on SNOWFLAKE database
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE CUSTOM_BUDGET_MONITOR;

-- Replace <username> with your own username
-- You need to use your own username to pass the DORA grading check later
GRANT ROLE CUSTOM_BUDGET_MONITOR TO USER <username>;

-- Verify role was created successfully
SHOW ROLES LIKE 'CUSTOM_BUDGET_MONITOR';

-- Note: Users with this role can:
-- - View specific custom budgets they have been granted access to
-- - Cannot view the account budget
-- - Cannot create or edit custom budgets

