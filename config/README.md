# How to Complete Lab Grading

This is where you can find the validation script you need to run to prove you completed the Snowflake Cost Management HOL.

Remember to edit your contact information in the SQL Statement for the SE_GREETER.sql
If all validations return ✅, you have successfully completed the Platform Performance Clustering HOL


**Important:** Replace `<YOUR_USERNAME>` in the validation script with your actual Snowflake username before running.

---

## ✅ Grading Steps

After completing ALL lab phases, run the comprehensive validation script:

### Complete Lab Validation

**Single comprehensive grading script validates all lab components:**

```sql
@Grading/DoraGrading_CostManagement_Complete.sql
```

**Run this after:** Completing all phases (before cleanup)

---

## 🎉 Success!

**If all 20 validation steps return STATUS = PASS, you have successfully completed the Snowflake Cost Management HOL!**

Total validation checks: **20 automated steps** in 1 comprehensive script

---

## ⚠️ Important Notes

### Before Running Validation:
- **Replace `<YOUR_USERNAME>`** in the script with your actual Snowflake username
  ```sql
  SET username = '<YOUR_USERNAME>';  -- Change to your actual username (usually in Uppercase)
  ```
- Ensure you're using the **ACCOUNTADMIN** role when running validation
- Complete all phases **before cleanup** (Phase 4 drops resources needed for validation)
- Ensure **util_db** database is available (required for se_grader function)

### After Cleanup (Phase 4):
- ⚠️ **Do NOT run validation after cleanup** - resources will be deleted
- Run validation **before** executing `07_cleanup_budgets.sql`
- Save validation results/screenshots before cleanup

### For Detailed Instructions:
📘 **See [GRADING_README.md](GRADING_README.md)** for comprehensive grading instructions, troubleshooting, and success criteria

---

## 📋 Validation Checklist

Use this checklist to track your progress:

- [ ] Phase 1 Complete: Setup and Prerequisites validated
- [ ] Phase 2 Complete: Budgets Setup validated
- [ ] Phase 3 Complete: Access Control validated
- [ ] Complete Lab: All components validated
- [ ] Screenshots saved (optional but recommended)
- [ ] Ready for cleanup (Phase 4)

---


