-- =====================================================================
-- Script: 02_create_snowsight_warehouse.sql
-- Purpose: Create a dedicated warehouse for running cost management queries
-- Description: This warehouse will be used by Snowsight to run all
--              cost management related queries and dashboards
-- =====================================================================

USE ROLE SYSADMIN;

CREATE WAREHOUSE IF NOT EXISTS SNOWSIGHT_WH 
    COMMENT = 'SNOWSIGHT Warehouse to be utilized for Snowsight dashboards, reports, etc.' 
    WAREHOUSE_SIZE = 'X-Small' 
    AUTO_RESUME = TRUE 
    AUTO_SUSPEND = 60 
    ENABLE_QUERY_ACCELERATION = FALSE 
    WAREHOUSE_TYPE = 'STANDARD' 
    MIN_CLUSTER_COUNT = 1 
    MAX_CLUSTER_COUNT = 1 
    SCALING_POLICY = 'STANDARD';

-- Verify the warehouse was created successfully
SHOW WAREHOUSES LIKE 'SNOWSIGHT_WH';

-- Note: After running this script, select SNOWSIGHT_WH as the 
-- warehouse in the Cost Management section of Snowsight

