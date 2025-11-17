-- =====================================================================
-- Script: 06_view_budget_linked_resources.sql
-- Purpose: View resources linked to custom budgets
-- Description: This script displays all warehouses and databases
--              associated with each custom budget
-- 
-- IMPORTANT: This script will FAIL if custom budgets haven't been 
--            created yet via Snowsight UI (Phase 2, Step 3).
--            The GET_LINKED_RESOURCES() procedure is automatically 
--            created when you create a budget in Snowsight.
-- =====================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE BUDGET_DB;
USE SCHEMA BUDGET_SCHEMA;
USE WAREHOUSE SNOWSIGHT_WH;

-- =====================================================================
-- STEP 1: Verify that custom budgets exist
-- =====================================================================
-- Method 1: Try to show procedures (this works if budgets exist)
-- If GET_LINKED_RESOURCES procedures exist, the budgets exist
SHOW PROCEDURES IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- Method 2: Alternative - List all objects in the schema
-- Look for objects that end with "!GET_LINKED_RESOURCES"
SHOW OBJECTS IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- If you see procedures like "CUSTOM_BUDGET_1!GET_LINKED_RESOURCES", 
-- your budgets exist and you can proceed.
-- 
-- If you DON'T see these procedures, go back to Phase 2, Step 3 
-- and create the custom budgets via Snowsight UI first.

-- =====================================================================
-- STEP 2: View the resources linked to each custom budget
-- =====================================================================
-- Only run this if CUSTOM_BUDGET_1 exists (verified above)
CALL BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!GET_LINKED_RESOURCES();

-- View the resources linked to CUSTOM_BUDGET_2
-- Note: Uncomment the line below if CUSTOM_BUDGET_2 exists
-- CALL BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_2!GET_LINKED_RESOURCES();

-- Note: This stored procedure helps you verify which resources
-- (warehouses and databases) are associated with each custom budget.
-- This is useful for understanding resource allocation and for
-- troubleshooting when resources appear to be missing from a budget.

-- =====================================================================
-- TROUBLESHOOTING COMMON ERRORS:
-- =====================================================================
-- 
-- Error 1: "Unknown user-defined function ... !GET_LINKED_RESOURCES"
-- Solution: The custom budget hasn't been created yet via Snowsight UI.
--           Go to: Admin → Cost Management → Budgets → Click "+" button
--           Create CUSTOM_BUDGET_1 with at least 2 warehouses
--
-- Error 2: "Object type or Class 'SNOWFLAKE.CORE.BUDGETS' does not exist"
-- Solution: This is expected - use the SHOW PROCEDURES method above instead.
--           The budget objects don't show up via SHOW BUDGETS command.
--           Look for the stored procedures that are created with each budget.
--
-- Error 3: "No procedures found" when running SHOW PROCEDURES
-- Solution: No custom budgets have been created yet.
--           Create them via Snowsight UI (Phase 2, Step 3)
-- =====================================================================

