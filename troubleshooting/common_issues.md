# Cost Management Troubleshooting Guide

This document provides solutions to common issues encountered during Snowflake cost management implementation.

---

## Table of Contents
- [Email and Notification Issues](#email-and-notification-issues)
- [Budget Creation Issues](#budget-creation-issues)
- [Role and Permission Issues](#role-and-permission-issues)
- [UI and Display Issues](#ui-and-display-issues)
- [Data and Reporting Issues](#data-and-reporting-issues)
- [Performance Issues](#performance-issues)

---

## Email and Notification Issues

### Issue: Email Verification Link Not Received
**Symptoms:**
- Cannot verify email address
- No email received after setting email in profile

**Diagnosis:**
```sql
-- Check if email is set for user
SHOW USERS LIKE '<username>';
-- Look at EMAIL column
```

**Solutions:**
1. Check spam/junk folder
2. Add `@snowflake.com` and `@snowflakecomputing.com` to email allowlist
3. Verify corporate email filters aren't blocking
4. Use "Resend verification email" link in Snowsight profile
5. Try a different email address (personal email for testing)

**Prevention:**
- Work with IT to allowlist Snowflake email domains before lab
- Use pre-verified email addresses when possible

---

### Issue: Budget Notifications Not Being Sent
**Symptoms:**
- Budget alerts not received despite exceeding thresholds
- Email is verified but no notifications

**Diagnosis:**
```sql
-- Verify notification settings
SHOW PARAMETERS LIKE 'ENABLE_UNREDACTED_QUERY_SYNTAX_ERROR' IN USER <username>;

-- Check if budget has email recipients configured
-- (View in Snowsight UI under Budget details)
```

**Solutions:**
1. Verify email address is verified in profile
2. Enable notifications for resource monitors in profile settings
3. Check that email recipients are configured in budget settings
4. Verify budget thresholds have actually been exceeded
5. Check if notification frequency is appropriate (daily vs. weekly)
6. Ensure user has not opted out of notifications

**Prevention:**
- Test notifications by temporarily setting a very low budget threshold
- Document all notification recipients in budget configuration

---

## Budget Creation Issues

### Issue: Cannot Create Custom Budget (Permission Denied)
**Symptoms:**
- Error: "Insufficient privileges to create budget"
- Budget creation button is disabled

**Diagnosis:**
```sql
-- Check current role
SELECT CURRENT_ROLE();

-- Check available roles
SHOW GRANTS TO USER <username>;
```

**Solutions:**
1. Switch to ACCOUNTADMIN role
2. Verify you have appropriate privileges
3. Have an ACCOUNTADMIN grant necessary privileges

**Prevention:**
- Always use ACCOUNTADMIN role for budget creation
- Document which roles can create/edit budgets

---

### Issue: BUDGET_DB Schema Not Available in Dropdown
**Symptoms:**
- BUDGET_DB.BUDGET_SCHEMA doesn't appear when creating custom budget
- Database exists but not visible in UI

**Diagnosis:**
```sql
-- Verify database and schema exist
SHOW DATABASES LIKE 'BUDGET_DB';
SHOW SCHEMAS IN DATABASE BUDGET_DB;

-- Check privileges
SHOW GRANTS ON DATABASE BUDGET_DB;
```

**Solutions:**
1. Click refresh icon next to database selector in Snowsight
2. Wait 10-15 seconds for UI cache to refresh
3. Hard refresh browser page (Ctrl+Shift+R or Cmd+Shift+R)
4. Clear browser cache and cookies
5. Try a different browser
6. Log out and log back into Snowsight

**Prevention:**
- Wait 30 seconds after creating database before using in UI
- Use SQL to verify objects exist before expecting them in UI

---

### Issue: Error Creating Budget Object
**Symptoms:**
- Error: "SQL compilation error"
- Budget creation fails with cryptic error

**Diagnosis:**
```sql
-- Verify no conflicting budget names
SHOW SNOWFLAKE.CORE.BUDGETS IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;
```

**Solutions:**
1. Ensure budget name is unique
2. Verify database and schema exist and are accessible
3. Check that you're using ACCOUNTADMIN role
4. Ensure proper syntax if creating via SQL

**Prevention:**
- Use naming conventions to avoid conflicts
- Create budgets via UI when possible (less error-prone)

---

## Role and Permission Issues

### Issue: Application Role Does Not Exist Error
**Symptoms:**
- Error: "Application role 'BUDGET_VIEWER' does not exist"
- Cannot grant budget viewer privileges

**Diagnosis:**
```sql
-- Check if application role exists
SHOW APPLICATION ROLES LIKE 'SNOWFLAKE.BUDGET_VIEWER';
```

**Solutions:**
1. Use correct syntax with `SNOWFLAKE.` prefix:
```sql
-- Correct
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE <role_name>;

-- Incorrect
GRANT APPLICATION ROLE BUDGET_VIEWER TO ROLE <role_name>;
```

2. Verify your Snowflake version supports budgets (released in 2023)

**Prevention:**
- Always include `SNOWFLAKE.` prefix for application roles
- Use provided scripts which have correct syntax

---

### Issue: User Cannot See Budgets After Role Assignment
**Symptoms:**
- Role is granted but budgets not visible
- User sees "No budgets" in Cost Management

**Diagnosis:**
```sql
-- Verify role grants
SHOW GRANTS TO ROLE <role_name>;

-- Verify user has role
SHOW GRANTS TO USER <username>;

-- Check if user is using the correct role
-- (User must manually switch to the role in Snowsight)
```

**Solutions:**
1. Grant `IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE`:
```sql
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE <role_name>;
```

2. Grant warehouse usage:
```sql
GRANT USAGE ON WAREHOUSE SNOWSIGHT_WH TO ROLE <role_name>;
```

3. Have user refresh Snowsight page
4. Verify user switches to the correct role in UI
5. Check that budget actually exists and has data

**Prevention:**
- Use provided scripts which include all necessary grants
- Document required privileges for each role
- Provide users with instructions on switching roles

---

### Issue: Cannot Grant Budget Access to Role
**Symptoms:**
- Error when granting `!VIEWER` access to budget
- Permission denied on budget object

**Diagnosis:**
```sql
-- Verify budget exists
SHOW SNOWFLAKE.CORE.BUDGETS IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- Check current role
SELECT CURRENT_ROLE();
```

**Solutions:**
1. Ensure you're using ACCOUNTADMIN role
2. Verify budget name and fully qualified path are correct
3. Use correct syntax:
```sql
GRANT SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.<budget_name>!VIEWER
  TO ROLE <role_name>;
```

4. Ensure budget has been created successfully

**Prevention:**
- Create budgets before attempting to grant access
- Use copy-paste to avoid typos in fully qualified names

---

### Issue: ACCOUNT_BUDGET_MONITOR Role Can Edit Account Budget
**Symptoms:**
- User with ACCOUNT_BUDGET_MONITOR role appears to have edit capabilities
- Three-dot menu (⋮) is visible next to account budget
- Can see "Edit Budget" buttons
- This should NOT be possible (role should be view-only)

**Diagnosis:**
```sql
-- Check which role you're currently using
SELECT CURRENT_ROLE();

-- If this returns ACCOUNTADMIN, you're not testing with the correct role
```

**Root Cause:**
99% of the time, this happens because the user hasn't actually switched to the ACCOUNT_BUDGET_MONITOR role in Snowsight. They're still using ACCOUNTADMIN role, which has full edit privileges.

**Solutions:**

1. **Verify you've switched roles in Snowsight:**
   - Look at the **top-right corner** of Snowsight interface
   - The role name should display **ACCOUNT_BUDGET_MONITOR**
   - If it shows **ACCOUNTADMIN** or any other role, you need to switch

2. **Properly switch to the role:**
   - Click the **role selector dropdown** in top-right corner
   - Select **ACCOUNT_BUDGET_MONITOR** from the list
   - Wait for the interface to refresh (3-5 seconds)
   - Navigate to Admin → Cost Management → Budgets
   - The three-dot menu should now be **missing or disabled**

3. **Verify the role has correct permissions:**
```sql
USE ROLE ACCOUNTADMIN;

-- Check what privileges the role has
SHOW GRANTS TO ROLE ACCOUNT_BUDGET_MONITOR;

-- Expected grants:
-- - APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER (view-only)
-- - IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE
-- - USAGE ON WAREHOUSE SNOWSIGHT_WH
```

4. **Test view-only access properly:**
   
   **You SHOULD be able to:**
   - ✅ See account budget tile
   - ✅ View spending graphs and trends
   - ✅ See credit usage data
   
   **You SHOULD NOT be able to:**
   - ❌ See three-dot menu (⋮) next to account budget
   - ❌ Click "Edit Budget" button
   - ❌ Modify spending limits
   - ❌ Change notification settings
   - ❌ Create new budgets (no + button)

5. **If still able to edit after switching roles:**
   - There may be a Snowflake version or UI issue
   - Run `SELECT CURRENT_VERSION();` to check your Snowflake version
   - Contact Snowflake Support with version information
   - According to [Snowflake documentation](https://docs.snowflake.com/en/user-guide/budgets/monitor), `SNOWFLAKE.BUDGET_VIEWER` provides view-only access

**Prevention:**
- Always verify current role before testing: `SELECT CURRENT_ROLE();`
- Take screenshots showing role selector in top-right corner
- Document testing results with role clearly indicated
- Create a test checklist that includes role verification as first step

**Reference:**
- [Snowflake Documentation - Monitoring Budgets](https://docs.snowflake.com/en/user-guide/budgets/monitor)
- [Budget Access Control](https://docs.snowflake.com/en/user-guide/budgets/access-control)

---

## UI and Display Issues

### Issue: Budgets Don't Appear After Creation
**Symptoms:**
- Budget created successfully but not visible in UI
- Budget tiles missing from Budgets page

**Diagnosis:**
- Check browser console for JavaScript errors (F12)
- Try accessing via SQL to confirm budget exists

**Solutions:**
1. Hard refresh page (Ctrl+Shift+R or Cmd+Shift+R)
2. Clear browser cache
3. Try different browser
4. Wait 2-3 minutes for UI to sync
5. Log out and log back in

**Prevention:**
- Allow time for UI synchronization after budget operations
- Keep browser and Snowsight updated

---

### Issue: Resource Consumption Shows as Zero
**Symptoms:**
- Budget shows $0 or 0 credits consumed
- No usage data visible despite active warehouses

**Diagnosis:**
```sql
-- Check if warehouses have actually been used
SELECT 
  WAREHOUSE_NAME,
  SUM(CREDITS_USED) as TOTAL_CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE START_TIME >= DATEADD(day, -7, CURRENT_TIMESTAMP())
GROUP BY WAREHOUSE_NAME;
```

**Solutions:**
1. Wait 2-4 hours for usage data to populate (data latency)
2. Ensure warehouses in budget have been actively used
3. Verify budget period includes dates with usage
4. Run some queries on the warehouses to generate usage
5. Check that resources are actually linked to budget

**Prevention:**
- Allow 24-48 hours for meaningful budget data after creation
- Test with warehouses that have recent usage history

---

### Issue: Resources Disappeared from Custom Budget
**Symptoms:**
- Warehouse or database no longer shows in budget
- Resource count decreased unexpectedly

**Diagnosis:**
```sql
-- Check which budgets the resource belongs to
CALL BUDGET_DB.BUDGET_SCHEMA.<budget_name>!GET_LINKED_RESOURCES();
```

**Solutions:**
1. Verify you didn't add resource to another budget (resources can only belong to one budget)
2. Check if resource was deleted from account
3. Verify you have permission to view the resource
4. Resource may have been intentionally removed

**Prevention:**
- Understand that resources automatically move when added to a new budget
- Document resource-to-budget assignments
- Use `GET_LINKED_RESOURCES()` regularly to audit assignments

---

## Data and Reporting Issues

### Issue: Budget Data Not Matching ACCOUNT_USAGE Views
**Symptoms:**
- Budget shows different credit consumption than account usage queries
- Discrepancy between UI and SQL results

**Diagnosis:**
```sql
-- Compare budget data with account usage
SELECT 
  DATE_TRUNC('day', START_TIME) as DAY,
  SUM(CREDITS_USED) as CREDITS
FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
WHERE WAREHOUSE_NAME IN ('WH1', 'WH2')  -- Replace with budget warehouses
  AND START_TIME >= DATE_TRUNC('month', CURRENT_TIMESTAMP())
GROUP BY DAY
ORDER BY DAY;
```

**Solutions:**
1. Account for data latency (ACCOUNT_USAGE has 45-minute to 3-hour lag)
2. Ensure comparing same time periods
3. Verify all resources are included in comparison
4. Check if budget includes storage costs vs. compute only

**Prevention:**
- Understand data latency in different Snowflake views
- Use ACCOUNT_USAGE for historical analysis, budgets for real-time monitoring
- Document what is/isn't included in budget calculations

---

### Issue: Unknown User-Defined Function Error for GET_LINKED_RESOURCES()
**Symptoms:**
- Error: "Unknown user-defined function BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!GET_LINKED_RESOURCES"
- SQL compilation error when calling the stored procedure

**Diagnosis:**
```sql
-- Check if custom budgets exist by looking for their procedures
SHOW PROCEDURES IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- Look for procedures named like "CUSTOM_BUDGET_1!GET_LINKED_RESOURCES"
```

**Alternative: Check in Snowsight UI**
- Navigate to Admin → Cost Management → Budgets
- Scroll down to custom budgets section
- If you see your budget tiles, they exist

**Root Cause:**
The `GET_LINKED_RESOURCES()` stored procedure is **automatically created** by Snowflake when you create a custom budget via Snowsight UI. If the budget doesn't exist, the procedure doesn't exist either.

**Solutions:**
1. **Create the custom budget first** via Snowsight UI:
   - Navigate to Admin → Cost Management → Budgets
   - Click the **+** button
   - Create CUSTOM_BUDGET_1 with at least 2 warehouses
   - See Phase 2, Step 3 in lab instructions

2. Verify budget was created successfully:
```sql
-- Check for procedures created with the budget
SHOW PROCEDURES IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;
-- You should see "CUSTOM_BUDGET_1!GET_LINKED_RESOURCES" procedure
```

   Or check in Snowsight UI:
   - Admin → Cost Management → Budgets
   - Look for CUSTOM_BUDGET_1 tile

3. Wait 10-20 seconds after creating the budget in UI before running SQL commands

4. Ensure you're using the exact budget name (case-sensitive):
```sql
-- Correct - matches exact name from Snowsight
CALL BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!GET_LINKED_RESOURCES();

-- Incorrect - wrong name
CALL BUDGET_DB.BUDGET_SCHEMA.CustomBudget1!GET_LINKED_RESOURCES();
```

**Prevention:**
- Always create custom budgets via Snowsight UI before running this script
- Follow Phase 2 instructions in order
- Use the verification query to confirm budget exists

---

### Issue: Object Type 'SNOWFLAKE.CORE.BUDGETS' Does Not Exist
**Symptoms:**
- Error: "Object type or Class 'SNOWFLAKE.CORE.BUDGETS' does not exist or not authorized"
- Occurs when running `SHOW SNOWFLAKE.CORE.BUDGETS` command

**Root Cause:**
The `SHOW SNOWFLAKE.CORE.BUDGETS` syntax may not be available in all Snowflake versions or might require different syntax depending on your edition.

**Solutions:**
1. **Use alternative verification method** - Check for stored procedures instead:
```sql
-- This shows procedures created when budgets are created
SHOW PROCEDURES IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- Or show all objects
SHOW OBJECTS IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;
```

2. **Verify in Snowsight UI** (most reliable method):
   - Navigate to Admin → Cost Management → Budgets
   - Scroll down to see custom budget tiles
   - If budgets exist, you'll see them here

3. **Check if budgets feature is available:**
   - Budgets are available in all Snowflake editions
   - Ensure you're using a recent version of Snowflake
   - Verify you have ACCOUNTADMIN role privileges

**Prevention:**
- Use UI verification method as primary check
- Use `SHOW PROCEDURES` as SQL alternative
- Don't rely solely on `SHOW SNOWFLAKE.CORE.BUDGETS` command

---

### Issue: GET_LINKED_RESOURCES() Returns Empty
**Symptoms:**
- Stored procedure executes but returns no results
- Cannot verify resource assignments

**Diagnosis:**
```sql
-- Verify budget exists
SHOW SNOWFLAKE.CORE.BUDGETS IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;

-- Check procedure syntax
DESC PROCEDURE BUDGET_DB.BUDGET_SCHEMA.<budget_name>!GET_LINKED_RESOURCES();
```

**Solutions:**
1. Verify budget name is correct and fully qualified
2. Ensure budget has resources assigned (check in Snowsight UI)
3. Resources may not have been added yet - go to budget in UI and add warehouses/databases
4. Use correct syntax:
```sql
CALL BUDGET_DB.BUDGET_SCHEMA.<budget_name>!GET_LINKED_RESOURCES();
```
5. Confirm you have privileges to call the procedure

**Prevention:**
- Test procedure immediately after creating budget and adding resources
- Keep documentation of budget names and locations

---

## Performance Issues

### Issue: Cost Management Interface is Slow
**Symptoms:**
- Snowsight Cost Management pages take long to load
- Queries timeout in Cost Management interface

**Diagnosis:**
```sql
-- Check warehouse size
SHOW WAREHOUSES LIKE 'SNOWSIGHT_WH';

-- Check if warehouse is suspended
SELECT * FROM TABLE(INFORMATION_SCHEMA.WAREHOUSE_METERING_HISTORY(
  DATE_RANGE_START => DATEADD(hour, -1, CURRENT_TIMESTAMP())
));
```

**Solutions:**
1. Ensure SNOWSIGHT_WH warehouse is selected and active
2. Increase warehouse size temporarily (X-Small → Small)
3. Clear browser cache
4. Check network connectivity
5. Try during off-peak hours

**Prevention:**
- Use appropriately sized warehouse for account size
- Keep SNOWSIGHT_WH running during active cost management sessions
- Monitor warehouse utilization

---

### Issue: Budget Calculations Taking Long Time
**Symptoms:**
- Budget tiles show "Loading..." for extended period
- Timeout errors when viewing budget details

**Solutions:**
1. Simplify budgets (fewer resources per budget)
2. Increase SNOWSIGHT_WH size for large accounts
3. Reduce date range being analyzed
4. Contact Snowflake support if issue persists

**Prevention:**
- Design budgets with reasonable resource counts
- Use appropriate warehouse sizes for account scale

---

## Getting Additional Help

### When to Contact Snowflake Support
- Persistent errors despite following troubleshooting steps
- Suspected product bugs or unexpected behavior
- Data integrity issues with budget calculations
- Performance issues that don't resolve with warehouse scaling

### Information to Provide
When contacting support, include:
1. Snowflake account identifier
2. Exact error messages and screenshots
3. Steps to reproduce the issue
4. SQL statements that fail (with sensitive data removed)
5. Browser version and OS (for UI issues)
6. Recent changes to account configuration

### Support Channels
- **Snowflake Support Portal:** https://support.snowflake.com/
- **Community Forums:** https://community.snowflake.com/
- **Documentation:** https://docs.snowflake.com/

---

## Document Version
**Version:** 1.0  
**Last Updated:** November 16, 2025  
**Maintained By:** Snowflake Solutions Engineering

*This document is continuously updated based on field feedback and new learnings.*

