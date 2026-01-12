-- =============================================================================
-- DORA GRADING SCRIPT: Snowflake Cost Management HOL - Complete Validation
-- =============================================================================
-- Lab: Cost Management - Budgets and Resource Monitors
-- Version: 1.0
-- Last Updated: November 16, 2025
-- =============================================================================
-- IMPORTANT: Replace <YOUR_USERNAME> with your actual Snowflake username
-- =============================================================================

USE ROLE ACCOUNTADMIN;
USE SCHEMA INFORMATION_SCHEMA;

-- Set username variable
SET username = '<YOUR_USERNAME>';

-- =============================================================================
-- PHASE 1: SETUP AND PREREQUISITES VALIDATION
-- =============================================================================

-- STEP 01: Validate user email is configured
SELECT
    util_db.public.se_grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO01' AS step,
        (
            SELECT COUNT(*) 
            FROM SNOWFLAKE.ACCOUNT_USAGE.USERS
            WHERE NAME = $username 
                AND EMAIL IS NOT NULL 
                AND EMAIL != ''
        ) AS actual,
        1 AS expected,
        'User email is configured for budget notifications' AS description
);

-- STEP 02: Validate SNOWSIGHT_WH warehouse exists
SELECT
    util_db.public.se_grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO02' AS step,
        (
            SELECT COUNT(*) 
            FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSES
            WHERE WAREHOUSE_NAME = 'SNOWSIGHT_WH'
                AND DELETED IS NULL
        ) AS actual,
        1 AS expected,
        'SNOWSIGHT_WH warehouse is created for Cost Management queries' AS description
);

-- =============================================================================
-- PHASE 2: BUDGETS SETUP VALIDATION
-- =============================================================================

-- STEP 03: Validate BUDGET_DB database exists
SELECT
    util_db.public.se_grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO03' AS step,
        (
            SELECT COUNT(*) 
            FROM SNOWFLAKE.ACCOUNT_USAGE.DATABASES
            WHERE DATABASE_NAME = 'BUDGET_DB'
                AND DELETED IS NULL
        ) AS actual,
        1 AS expected,
        'BUDGET_DB database is created for storing custom budgets' AS description
);

-- STEP 04: Validate BUDGET_SCHEMA schema exists
SELECT
    util_db.public.se_grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO04' AS step,
        (
            SELECT COUNT(*) 
            FROM SNOWFLAKE.ACCOUNT_USAGE.SCHEMATA
            WHERE CATALOG_NAME = 'BUDGET_DB'
                AND SCHEMA_NAME = 'BUDGET_SCHEMA'
                AND DELETED IS NULL
        ) AS actual,
        1 AS expected,
        'BUDGET_SCHEMA schema is created in BUDGET_DB database' AS description
);

-- STEP 05: Validate CUSTOM_BUDGET_1 exists (via stored procedure)
SELECT
    util_db.public.se_grader(
        step,
        (actual >= expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO05' AS step,
        (
            SELECT COUNT(*) 
            FROM BUDGET_DB.INFORMATION_SCHEMA.PROCEDURES
            WHERE PROCEDURE_SCHEMA = 'BUDGET_SCHEMA'
                AND PROCEDURE_NAME LIKE '%CUSTOM_BUDGET_1%GET_LINKED_RESOURCES%'
        ) AS actual,
        1 AS expected,
        'CUSTOM_BUDGET_1 is created (procedure exists for budget object)' AS description
);

-- STEP 06: Validate CUSTOM_BUDGET_2 exists (via stored procedure)
SELECT
    util_db.public.se_grader(
        step,
        (actual >= expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO06' AS step,
        (
            SELECT COUNT(*) 
            FROM BUDGET_DB.INFORMATION_SCHEMA.PROCEDURES
            WHERE PROCEDURE_SCHEMA = 'BUDGET_SCHEMA'
                AND PROCEDURE_NAME LIKE '%CUSTOM_BUDGET_2%GET_LINKED_RESOURCES%'
        ) AS actual,
        1 AS expected,
        'CUSTOM_BUDGET_2 is created (procedure exists for budget object)' AS description
);

-- =============================================================================
-- PHASE 3: ACCESS CONTROL VALIDATION
-- =============================================================================

-- STEP 7: Validate ACCOUNT_BUDGET_MONITOR role exists
SELECT
    util_db.public.se_grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO07' AS step,
        (
            SELECT COUNT(*) 
            FROM SNOWFLAKE.ACCOUNT_USAGE.ROLES
            WHERE NAME = 'ACCOUNT_BUDGET_MONITOR'
                AND DELETED_ON IS NULL
        ) AS actual,
        1 AS expected,
        'ACCOUNT_BUDGET_MONITOR role is created for viewing account budget' AS description
);

-- STEP 08: Validate CUSTOM_BUDGET_MONITOR role exists
SELECT
    util_db.public.se_grader(
        step,
        (actual = expected),
        actual,
        expected,
        description
    ) AS graded_results
FROM (
    SELECT
        'SEPFO08' AS step,
        (
            SELECT COUNT(*) 
            FROM SNOWFLAKE.ACCOUNT_USAGE.ROLES
            WHERE NAME = 'CUSTOM_BUDGET_MONITOR'
                AND DELETED_ON IS NULL
        ) AS actual,
        1 AS expected,
        'CUSTOM_BUDGET_MONITOR role is created for viewing custom budgets' AS description
);


