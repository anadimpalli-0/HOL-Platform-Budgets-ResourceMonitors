# Phase 1: Setup and Prerequisites

**Estimated Time:** 15-20 minutes

## Overview
In this phase, you'll set up the foundational components needed for cost management in Snowflake, including email notifications and the dedicated warehouse for running cost management queries.

---

## Step 1: Verify ACCOUNTADMIN Email Notifications

### 1.1 Check Your Profile
1. Log into Snowsight using the **ACCOUNTADMIN** role
2. Click on settings tab
3. Select **My Profile**

### 1.2 Set Email Address (if not already configured) either through snowsight or by running the following script

<img src="/images/Emailsetup.png" width="70%">

If your email address is not set or verified:

1. Navigate to **scripts/01_setup_email_notifications.sql**
2. Replace the following placeholders:
   - `<username>` with your actual Snowflake username
   - `<email@address>` with your actual email address
3. Run the script in Snowsight

```sql
ALTER USER <username> SET EMAIL='<email@address>';
```

### 1.3 Verify Email Address
1. Check your email inbox for a verification email from Snowflake
2. Click the verification link in the email
3. If you don't receive the email, you can resend it from your profile page

### 1.4 Enable Notifications for Resource Monitors
1. Return to your profile in Snowsight after email verification
2. Enable the option for **notifications for resource monitors**
3. This ensures you'll receive alerts when budgets or resource monitors are triggered

<img src="/images/notification.png" width="70%">
---

## Step 2: Create the Snowsight Warehouse

### 2.1 Why a Dedicated Warehouse?
Snowflake's Cost Management interface requires a dedicated warehouse to run queries for:
- Budget calculations
- Cost analysis dashboards
- Resource usage reports

### 2.2 Create the Warehouse
1. Navigate to **scripts/02_create_snowsight_warehouse.sql**
2. Review the warehouse configuration:
   - **Size:** X-Small (cost-efficient for monitoring queries)
   - **Auto-Suspend:** 60 seconds (minimizes idle costs)
   - **Auto-Resume:** Enabled (ensures queries can run on-demand)
3. Run the script in Snowsight

The warehouse will be created with these specifications:
- Warehouse Name: `SNOWSIGHT_WH`
- Size: X-Small
- Auto-Suspend: 60 seconds
- Single cluster configuration

### 2.3 Select the Warehouse in Cost Management
1. Navigate to **Admin** → **Cost Management** in Snowsight
2. You'll be prompted to select a warehouse for running cost management queries
3. Click on **Select Warehouse**
4. Choose **SNOWSIGHT_WH** from the dropdown
5. Confirm your selection

---

## Step 3: Navigate to Cost Management Interface

### 3.1 Access Cost Management
1. In Snowsight, click on **Admin** in the left sidebar
2. Select **Cost Management**
3. You should now see the Cost Management dashboard

### 3.2 Familiarize Yourself with the Interface
Take a moment to explore:
- **Account Overview:** Overview of credit consumption across your account
- **Consumption:** Detailed breakdown by warehouse, database, or user
- **Budgets:** Where you'll set up account and custom budgets
- **Resource Monitors:** Where you'll set up resource monitors to track spending thresholds, preventing budget overruns before they happen.

<img src="/images/notification.png" width="70%">
---

## Checkpoint ✓

Before proceeding to Phase 2, verify:
- [ ] Email address is set and verified for ACCOUNTADMIN user
- [ ] Notifications for resource monitors are enabled
- [ ] SNOWSIGHT_WH warehouse is created and active
- [ ] SNOWSIGHT_WH is selected in the Cost Management interface
- [ ] You can access the Cost Management dashboard

---

## Troubleshooting

**Issue:** Can't verify email address  
**Solution:** Check your spam folder. If still not received, contact your email administrator to ensure Snowflake emails aren't blocked.

**Issue:** Can't create warehouse (insufficient privileges)  
**Solution:** Ensure you're using the SYSADMIN role. If you still can't create the warehouse, verify you have the CREATE WAREHOUSE privilege.

**Issue:** SNOWSIGHT_WH doesn't appear in the warehouse selector  
**Solution:** Refresh the Snowsight page. If it still doesn't appear, verify the warehouse was created successfully using `SHOW WAREHOUSES;`

---

## Next Steps
Proceed to [Phase 2: Setting Up Budgets](phase2_setting_up_budgets.md)

