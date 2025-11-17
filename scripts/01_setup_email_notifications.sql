-- =====================================================================
-- Script: 01_setup_email_notifications.sql
-- Purpose: Configure email notifications for ACCOUNTADMIN user
-- Description: This script sets up email notifications which are 
--              required for receiving budget alerts and resource 
--              monitor notifications
-- =====================================================================

USE ROLE ACCOUNTADMIN;

-- Replace <username> with the actual username
-- Replace <email@address> with the actual email address
ALTER USER <username> SET EMAIL='<email@address>';

-- Note: After running this script:
-- 1. Check your inbox for a verification email
-- 2. Click the verification link in the email
-- 3. Go to your profile in Snowsight
-- 4. Enable notifications for resource monitors

