# Phase 3: Access Control for Budgets

**Estimated Time:** 20-25 minutes

## Overview
In this phase, you'll set up role-based access control (RBAC) to allow non-ACCOUNTADMIN users to view budgets without the ability to modify them.

---

## Step 1: Understanding Budget Visibility

### 1.1 Default ACCOUNTADMIN Access
By default, only users with the **ACCOUNTADMIN** role can:
- View the Cost Management interface
- See account-level and custom budgets
- Create, edit, and delete budgets
- Configure budget notifications

### 1.2 ACCOUNTADMIN View in Cost Management
When logged in as ACCOUNTADMIN, you see:
- **Budgets** header in the Cost Management navigation
- Account budget details
- All custom budgets
- Full edit capabilities

### 1.3 Non-ACCOUNTADMIN View (Before Configuration)
When non-ACCOUNTADMIN users access Cost Management:
- They see basic usage information
- **No "Budgets" header** in the navigation
- Cannot view any budget information
- This limits transparency and cost awareness

### 1.4 The Solution: Custom Roles
We'll create two specialized roles:
1. **ACCOUNT_BUDGET_MONITOR:** View-only access to account budget
2. **CUSTOM_BUDGET_MONITOR:** View-only access to specific custom budgets

---

## Step 2: Create Account Budget Monitor Role

### 2.1 Purpose of This Role
The `ACCOUNT_BUDGET_MONITOR` role provides:
- **Read-only** access to the account-level budget
- No ability to edit or delete the account budget
- No access to custom budgets
- No ability to create new budgets

This is ideal for:
- Finance team members
- Department heads who need visibility into overall spending
- Auditors reviewing account-level costs

### 2.2 Create the Role
1. Navigate to **scripts/04_create_account_budget_monitor_role.sql**
2. **Important:** Replace `<username>` with your actual Snowflake username
3. Review the script components:

```sql
-- Create the role
CREATE ROLE IF NOT EXISTS ACCOUNT_BUDGET_MONITOR;

-- Grant budget viewer application role
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE ACCOUNT_BUDGET_MONITOR;

-- Grant access to Snowflake database for cost management
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE ACCOUNT_BUDGET_MONITOR;

-- Grant role to user
GRANT ROLE ACCOUNT_BUDGET_MONITOR TO USER <username>;

-- Grant warehouse access
GRANT USAGE ON WAREHOUSE SNOWSIGHT_WH TO ROLE ACCOUNT_BUDGET_MONITOR;
```

4. Run the script in Snowsight

### 2.3 Test the Role (IMPORTANT - Follow Carefully)

**Step 1: Switch to the ACCOUNT_BUDGET_MONITOR role**
1. In Snowsight, click on your **role selector** in the top-right corner
2. Select **ACCOUNT_BUDGET_MONITOR** from the dropdown
3. **Verify the role name shows "ACCOUNT_BUDGET_MONITOR" in top-right** (NOT ACCOUNTADMIN)

**Step 2: Navigate to Cost Management**
1. Go to **Admin** → **Cost Management** → **Budgets**

**Step 3: Verify VIEW-ONLY Access**

✅ **You SHOULD be able to:**
- See the account budget tile
- View budget details and spending trends
- See credit usage graphs
- View budget notifications history (if any)

❌ **You SHOULD NOT be able to:**
- **Three-dot menu (⋮) should be missing or disabled** next to account budget
- No "Edit Budget" button should appear
- Cannot modify the spending limit
- Cannot change email notification settings
- Cannot deactivate the budget
- Cannot see custom budgets section at all
- No "+" button to create new budgets

**Step 4: Test Edit Restrictions**
1. Click on the account budget tile to open details
2. Look for any edit buttons or controls - they should be **absent or grayed out**
3. If you see edit options, **you're still in ACCOUNTADMIN role** - check step 1 again

**Reference:** [Snowflake Documentation - Monitoring Budgets](https://docs.snowflake.com/en/user-guide/budgets/monitor)

### 2.4 What Users See with ACCOUNT_BUDGET_MONITOR Role

**In the Budgets Interface:**
- ✅ Account budget tile and summary
- ✅ Current spending vs. budget comparison
- ✅ Budget utilization trends and graphs
- ✅ Daily credit usage breakdown
- ❌ **No custom budgets section visible**
- ❌ No "Create Budget" (+) button
- ❌ No edit controls (three-dot menu, edit buttons)
- ❌ Cannot modify any budget settings

**Important:** If you can see edit options or custom budgets, you haven't properly switched to the ACCOUNT_BUDGET_MONITOR role. Check your role selector in the top-right corner.

---

## Step 3: Create Custom Budget Monitor Role

### 3.1 Purpose of This Role
The `CUSTOM_BUDGET_MONITOR` role provides:
- **Read-only** access to specific custom budgets
- No access to the account budget
- No ability to edit or delete budgets
- No ability to create new budgets

This is ideal for:
- Project managers monitoring project-specific spending
- Team leads tracking their team's warehouse costs
- Department-specific cost visibility

### 3.2 Create the Role
1. Navigate to **scripts/05_create_custom_budget_monitor_role.sql**
2. **Important:** Replace `<username>` with your actual Snowflake username
3. Review the script components:

```sql
-- Create the role
CREATE ROLE IF NOT EXISTS CUSTOM_BUDGET_MONITOR;

-- Grant access to budget database and schema
GRANT USAGE ON DATABASE BUDGET_DB TO ROLE CUSTOM_BUDGET_MONITOR;
GRANT USAGE ON SCHEMA BUDGET_DB.BUDGET_SCHEMA TO ROLE CUSTOM_BUDGET_MONITOR;

-- Grant access to specific custom budget (CUSTOM_BUDGET_1)
GRANT SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!VIEWER
  TO ROLE CUSTOM_BUDGET_MONITOR;

-- Grant other required privileges
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE CUSTOM_BUDGET_MONITOR;
GRANT USAGE ON WAREHOUSE SNOWSIGHT_WH TO ROLE CUSTOM_BUDGET_MONITOR;

-- Grant role to user
GRANT ROLE CUSTOM_BUDGET_MONITOR TO USER <username>;
```

4. Run the script in Snowsight

### 3.3 Understanding Budget-Specific Grants
The key line is:
```sql
GRANT SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!VIEWER
  TO ROLE CUSTOM_BUDGET_MONITOR;
```

This syntax:
- Grants access to a **specific budget object** (`CUSTOM_BUDGET_1`)
- Uses the **!VIEWER** suffix to provide read-only access
- Is **budget-specific** - you must grant access to each budget individually

### 3.4 Test the Role
1. Switch to the **CUSTOM_BUDGET_MONITOR** role in Snowsight

2. Navigate to **Admin** → **Cost Management** → **Budgets**

3. Verify the following:
   - ✗ You **cannot see** the account budget
   - ✓ You **can see** CUSTOM_BUDGET_1
   - ✗ You **cannot see** CUSTOM_BUDGET_2 (not granted access)
   - ✓ Budget details and resource breakdown are visible
   - ✗ You **cannot edit** the budget
   - ✗ You **cannot create** new budgets

4. Click on **CUSTOM_BUDGET_1** tile to view details

---

## Step 4: Granting Access to Multiple Custom Budgets

### 4.1 Adding Access to Additional Budgets
To grant the `CUSTOM_BUDGET_MONITOR` role access to `CUSTOM_BUDGET_2`:

```sql
USE ROLE ACCOUNTADMIN;

GRANT SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_2!VIEWER
  TO ROLE CUSTOM_BUDGET_MONITOR;
```

### 4.2 Verify Access
1. Stay in the **CUSTOM_BUDGET_MONITOR** role
2. Refresh the Budgets page
3. You should now see both CUSTOM_BUDGET_1 and CUSTOM_BUDGET_2

### 4.3 Best Practice: Granular Access
**Recommendation:** Instead of granting one role access to all budgets, consider:
- Creating separate roles for different budget scopes
- Example: `DEPT_A_BUDGET_MONITOR`, `DEPT_B_BUDGET_MONITOR`
- This ensures teams only see their own budget information

---

## Step 5: Role Hierarchy and Best Practices

### 5.1 Recommended Role Hierarchy
```
ACCOUNTADMIN
├── ACCOUNT_BUDGET_MONITOR (view account budget only)
├── CUSTOM_BUDGET_MONITOR (view specific custom budgets)
└── TEAM_SPECIFIC_BUDGET_ROLES (team-specific budget access)
```

### 5.2 Security Best Practices
1. **Principle of Least Privilege:**
   - Only grant the minimum access needed
   - Use `!VIEWER` suffix for read-only access

2. **Separate Concerns:**
   - Don't combine account and custom budget access in one role
   - Create specific roles for specific purposes

3. **Audit Regularly:**
   - Review who has access to budget information
   - Revoke access when team members change roles

4. **Documentation:**
   - Document which roles have access to which budgets
   - Maintain a mapping of roles to teams/departments

### 5.3 Revoking Access
To remove budget access from a role:

```sql
USE ROLE ACCOUNTADMIN;

-- Revoke custom budget access
REVOKE SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1!VIEWER
  FROM ROLE CUSTOM_BUDGET_MONITOR;

-- Revoke account budget access
REVOKE APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER FROM ROLE ACCOUNT_BUDGET_MONITOR;
```

---

## Checkpoint ✓

Before proceeding to Phase 4, verify:
- [ ] ACCOUNT_BUDGET_MONITOR role is created
- [ ] ACCOUNT_BUDGET_MONITOR role can view the account budget
- [ ] ACCOUNT_BUDGET_MONITOR role cannot view custom budgets
- [ ] CUSTOM_BUDGET_MONITOR role is created
- [ ] CUSTOM_BUDGET_MONITOR role can view CUSTOM_BUDGET_1
- [ ] CUSTOM_BUDGET_MONITOR role cannot view the account budget
- [ ] You understand how to grant access to specific budgets
- [ ] Both roles are granted to your user account

---

## Troubleshooting

**Issue:** Role created but can't see budgets  
**Solution:** 
1. Ensure you've granted `IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE`
2. Verify the role has `USAGE` on `SNOWSIGHT_WH` warehouse
3. Refresh the Snowsight page after switching roles

**Issue:** Error: "Application role does not exist"  
**Solution:** Ensure you're using `SNOWFLAKE.BUDGET_VIEWER` (not `BUDGET_VIEWER`). The application role name must include the `SNOWFLAKE.` prefix.

**Issue:** Can't grant !VIEWER to role  
**Solution:** 
1. Verify the custom budget exists: `SHOW SNOWFLAKE.CORE.BUDGETS;`
2. Ensure you're using ACCOUNTADMIN role
3. Check the database and schema names are correct

**Issue:** User can't switch to the new role  
**Solution:** Verify the role was granted to the user:
```sql
SHOW GRANTS TO USER <username>;
```

---

## Next Steps
Proceed to [Phase 4: Cleanup and Best Practices](phase4_cleanup_and_best_practices.md)

