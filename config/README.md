# How to Complete Lab Grading

This is where you can find the validation script you need to run to prove you completed the Snowflake Cost Management HOL.

Remember to edit your contact information in the SQL Statement for the [SE_GREETER.sql](SE_GREETER.sql)

If all validations return ✅, you have successfully completed the HOL


**Important:** Replace `<YOUR_USERNAME>` in the validation script with your actual Snowflake username before running.

---
## ⚠️ Important Notes

### Before Running Validation:
- **Replace `<YOUR_USERNAME>`** in the script with your actual Snowflake username
  ```sql
  SET username = '<YOUR_USERNAME>';  -- Change to your actual username (usually in Uppercase)
  ```
- Ensure you're using the **ACCOUNTADMIN** role when running validation
- Complete all phases **before cleanup** (Phase 4 drops resources needed for validation)
---

## ✅ Grading Steps

After completing ALL lab phases, run the comprehensive validation script:

### Complete Lab Validation

**Single comprehensive grading script validates all lab components:**
[Script to Execute](DoraGrading_CostManagement_Complete.sql)

**Run this after:** Completing all phases (before cleanup)

---

## 🎉 Success!

**If all validation steps return STATUS = PASS, you have successfully completed the Snowflake Cost Management HOL!**

---

# Next Steps
## CleanUp

Clean up all the Objects created during the lab

Ensure that all the validations return ✅ before you cleanup the Objects.

[Cleanup Script to Execute](/scripts/07_cleanup_budgets.sql)

