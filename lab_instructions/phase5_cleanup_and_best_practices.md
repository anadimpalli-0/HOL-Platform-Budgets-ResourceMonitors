# Phase 4: Cleanup and Best Practices

**Estimated Time:** 10-15 minutes

## Overview
In this final phase, you'll clean up the resources created during the lab and learn best practices for cost management in production environments.

---

## Step 1: Understanding What to Clean Up

### 1.1 Resources to Remove
After completing this lab, you should clean up:
- ✓ **Custom budgets** (CUSTOM_BUDGET_1, CUSTOM_BUDGET_2)
- ✓ **Budget database** (optional - if not needed for future use)

### 1.2 Resources to Keep
The following resources should typically be **retained** for ongoing cost management:
- ✓ **SNOWSIGHT_WH warehouse** (for cost management queries)
- ✓ **Account budget** (continues monitoring account-level spending)
- ✓ **ACCOUNT_BUDGET_MONITOR role** (for non-admin users)
- ✓ **CUSTOM_BUDGET_MONITOR role** (reusable for future budgets)

---

## Step 2: Drop Custom Budgets

### 2.1 Option 1: Drop Using Snowsight UI

#### Drop CUSTOM_BUDGET_1:
1. Navigate to **Admin** → **Cost Management** → **Budgets**
2. Ensure you're using the **ACCOUNTADMIN** role
3. Click on the **CUSTOM_BUDGET_1** tile
4. Click the **trash can** icon (🗑️) in the top-right corner
5. In the confirmation dialog, click **Drop Budget**

#### Drop CUSTOM_BUDGET_2:
Repeat the same process for CUSTOM_BUDGET_2

### 2.2 Option 2: Drop Using SQL

Navigate to **scripts/07_cleanup_budgets.sql** and run:

```sql
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE SNOWSIGHT_WH;
USE DATABASE BUDGET_DB;
USE SCHEMA BUDGET_SCHEMA;

-- Drop custom budgets
DROP SNOWFLAKE.CORE.BUDGET IF EXISTS BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_2;
DROP SNOWFLAKE.CORE.BUDGET IF EXISTS BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1;
```

### 2.3 Verify Deletion
1. Refresh the Budgets page in Snowsight
2. Verify that only the account budget is visible
3. Custom budget tiles should no longer appear

**Note:** You may need to hard-refresh (Ctrl+Shift+R or Cmd+Shift+R) for the UI to update

### 2.4 Verify Using SQL
```sql
-- This should return no results if budgets are dropped
SHOW SNOWFLAKE.CORE.BUDGETS IN SCHEMA BUDGET_DB.BUDGET_SCHEMA;
```

---

## Step 3: Optional Complete Cleanup

### 3.1 When to Perform Complete Cleanup
Perform complete cleanup if:
- This is a temporary demo account
- You won't be using cost management features going forward
- You need to remove all lab-related resources

### 3.2 Complete Cleanup Script
If you want to remove **all** resources created in this lab:

```sql
USE ROLE ACCOUNTADMIN;

-- Drop custom budgets (if not already done)
DROP SNOWFLAKE.CORE.BUDGET IF EXISTS BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_2;
DROP SNOWFLAKE.CORE.BUDGET IF EXISTS BUDGET_DB.BUDGET_SCHEMA.CUSTOM_BUDGET_1;

-- Drop the budget database
DROP DATABASE IF EXISTS BUDGET_DB;

-- Drop custom roles
DROP ROLE IF EXISTS ACCOUNT_BUDGET_MONITOR;
DROP ROLE IF EXISTS CUSTOM_BUDGET_MONITOR;

-- Drop the Snowsight warehouse
DROP WAREHOUSE IF EXISTS SNOWSIGHT_WH;
```

### 3.3 Account Budget Cleanup
To disable the account budget:
1. Navigate to **Admin** → **Cost Management** → **Budgets**
2. Click the **⋮** (three dots) menu next to the account budget
3. Select **Deactivate Budget**
4. Confirm deactivation

**Note:** You typically want to **keep the account budget active** even after cleanup

---

## Step 4: Cost Management Best Practices

### 4.1 Budget Configuration Best Practices

#### Set Realistic Budget Targets
- Base budgets on historical usage data
- Add 10-20% buffer for unexpected growth
- Review and adjust budgets quarterly

#### Configure Appropriate Notifications
- **Daily notifications:** For fast-moving projects
- **Weekly notifications:** For steady-state workloads
- **Multiple recipients:** Include finance and technical leads

#### Layer Your Budgets
```
Account Budget (Organization Level)
├── Department A Custom Budget
│   ├── Warehouse A1
│   └── Warehouse A2
├── Department B Custom Budget
│   ├── Warehouse B1
│   └── Warehouse B2
└── Shared Services Custom Budget
    ├── Shared Warehouse
    └── Shared Database
```

### 4.2 Warehouse Cost Optimization

#### Right-Size Warehouses
- Start with smaller warehouse sizes
- Scale up only when needed
- Use query profiles to identify bottlenecks

#### Configure Auto-Suspend
```sql
-- Short auto-suspend for interactive workloads
ALTER WAREHOUSE INTERACTIVE_WH SET AUTO_SUSPEND = 60;

-- Longer auto-suspend for batch workloads
ALTER WAREHOUSE BATCH_WH SET AUTO_SUSPEND = 300;
```

#### Implement Resource Monitors
Resource monitors provide **hard limits** vs. budgets (which only notify):

```sql
USE ROLE ACCOUNTADMIN;

CREATE RESOURCE MONITOR WAREHOUSE_LIMIT
  WITH CREDIT_QUOTA = 100
  FREQUENCY = MONTHLY
  START_TIMESTAMP = IMMEDIATELY
  TRIGGERS
    ON 75 PERCENT DO NOTIFY
    ON 90 PERCENT DO SUSPEND
    ON 100 PERCENT DO SUSPEND_IMMEDIATE;

-- Apply to specific warehouse
ALTER WAREHOUSE COMPUTE_WH SET RESOURCE_MONITOR = WAREHOUSE_LIMIT;
```

### 4.3 Role-Based Access Control Best Practices

#### Implement Least Privilege
```sql
-- Finance team: view all budgets
CREATE ROLE FINANCE_BUDGET_VIEWER;
GRANT APPLICATION ROLE SNOWFLAKE.BUDGET_VIEWER TO ROLE FINANCE_BUDGET_VIEWER;

-- Team leads: view only their team's budget
CREATE ROLE TEAM_A_BUDGET_VIEWER;
GRANT SNOWFLAKE.CORE.BUDGET ROLE BUDGET_DB.BUDGET_SCHEMA.TEAM_A_BUDGET!VIEWER
  TO ROLE TEAM_A_BUDGET_VIEWER;
```

#### Separate Administrative Access
- **Budget creation:** Only ACCOUNTADMIN
- **Budget viewing:** Specialized viewer roles
- **Budget editing:** Limited to finance team

### 4.4 Monitoring and Alerting Strategy

#### Set Up Multi-Tier Alerts
1. **75% threshold:** Warning notification to technical team
2. **90% threshold:** Alert to technical and finance teams
3. **100% threshold:** Suspend warehouse (for resource monitors)

#### Regular Review Cadence
- **Daily:** Check budget consumption during high-activity periods
- **Weekly:** Review warehouse utilization and right-sizing opportunities
- **Monthly:** Analyze trends and adjust budgets for next month
- **Quarterly:** Review overall cost management strategy

### 4.5 Cost Insights and Optimization

#### Use Cost Management Tools
1. **Consumption Tab:** Identify top consumers
   - Warehouses with highest credit usage
   - Users generating most queries
   - Databases with most storage costs

2. **Optimization Tab:** Review recommendations
   - Idle warehouses to suspend
   - Oversized warehouses to downsize
   - Storage optimization opportunities

#### Query Optimization
- Use `RESULT_CACHE` for repeated queries
- Implement clustering keys for large tables
- Partition data by query patterns
- Use materialized views for complex aggregations

### 4.6 Documentation and Governance

#### Document Budget Ownership
Create a budget ownership matrix:

| Budget Name | Owner | Department | Purpose | Alert Recipients |
|-------------|-------|------------|---------|------------------|
| Account Budget | CFO | Finance | Overall spending | finance@company.com |
| Engineering_Budget | VP Eng | Engineering | Dev/prod workloads | eng-leads@company.com |
| Analytics_Budget | Head of Analytics | Analytics | BI and reporting | analytics@company.com |

#### Implement Change Management
- Require approval for budget increases
- Document reasons for budget adjustments
- Track budget vs. actual spending monthly

---

## Step 5: Production Deployment Checklist

### 5.1 Before Going to Production
- [ ] Account budget is configured with appropriate limit
- [ ] Email notifications are set up for budget alerts
- [ ] Custom budgets are created for each department/team
- [ ] Non-admin roles have appropriate read-only access
- [ ] Resource monitors are configured for critical warehouses
- [ ] Warehouse auto-suspend is configured (60-300 seconds)
- [ ] Documentation exists for budget ownership and processes
- [ ] Finance team has been trained on budget monitoring

### 5.2 Ongoing Maintenance
- [ ] Review budget consumption weekly
- [ ] Adjust budgets quarterly based on trends
- [ ] Audit role assignments monthly
- [ ] Review cost optimization recommendations weekly
- [ ] Update documentation when budgets change

---

## Checkpoint ✓

You have successfully completed the Cost Management Hands-On Lab! Verify:
- [ ] Custom budgets have been dropped (or retained if needed)
- [ ] You understand which resources to keep vs. remove
- [ ] You can configure budgets for production use
- [ ] You understand best practices for cost management
- [ ] You can set up role-based access to budgets
- [ ] You know how to monitor and optimize costs

---

## Additional Resources

### Snowflake Documentation
- [Monitoring Credit Usage with Budgets](https://docs.snowflake.com/en/user-guide/budgets)
- [Creating and Managing Budgets](https://docs.snowflake.com/en/user-guide/cost-exploring-budgets)
- [Resource Monitors](https://docs.snowflake.com/en/user-guide/resource-monitors)
- [Warehouse Considerations](https://docs.snowflake.com/en/user-guide/warehouses-considerations)

### Snowflake Tutorials
- [Getting Started with Budgets](https://docs.snowflake.com/en/user-guide/budgets-getting-started)
- [Cost Management Best Practices](https://docs.snowflake.com/en/user-guide/cost-management)

### Community Resources
- Snowflake Community Forums
- Snowflake User Groups
- Snowflake Blog: Cost Optimization Series

---

## Feedback

We value your feedback! Please share:
- What worked well in this lab
- Areas for improvement
- Additional topics you'd like to see covered
- Questions or challenges you encountered

---

## Congratulations! 🎉

You've completed the Cost Management Hands-On Practice lab and are now equipped to:
- Configure and manage budgets in Snowflake
- Set up role-based access to cost information
- Implement cost optimization best practices
- Monitor and control warehouse spending
- Deploy cost management features in production

Keep exploring Snowflake's cost management capabilities to maximize value from your usage-based pricing!

