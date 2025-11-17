-- =====================================================================
-- Script: 03_create_budget_database.sql
-- Purpose: Create database and schema for managing custom budgets
-- Description: This database will store all custom budget objects
--              and related configurations
-- =====================================================================

USE ROLE SYSADMIN;

-- Create database for storing custom budgets
CREATE DATABASE IF NOT EXISTS BUDGET_DB;

-- Create schema within the budget database
CREATE SCHEMA IF NOT EXISTS BUDGET_DB.BUDGET_SCHEMA;

-- Verify the database and schema were created
SHOW DATABASES LIKE 'BUDGET_DB';
SHOW SCHEMAS IN DATABASE BUDGET_DB;

-- Note: If BUDGET_DB.BUDGET_SCHEMA are not available in Snowsight:
-- 1. Refresh the list of databases in Snowsight
-- 2. If that doesn't work, refresh the whole Snowsight page

