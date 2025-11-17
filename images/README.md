# Image Assets for Cost Management HOL

This directory contains visual assets used throughout the Cost Management Hands-On Lab.

## Required Images

### Architecture Diagram
- **Filename:** `cost_management_architecture.png`
- **Purpose:** High-level overview of Snowflake cost management components
- **Recommended Content:**
  - Snowflake account with warehouses and databases
  - Cost Management interface
  - Budget objects (account and custom)
  - Email notification flow
  - Role-based access control visualization

### Phase Screenshots

#### Phase 1: Setup and Prerequisites
- `snowsight_profile_email.png` - Email configuration in user profile
- `select_warehouse_dialog.png` - Warehouse selection in Cost Management
- `cost_management_dashboard.png` - Main Cost Management interface

#### Phase 2: Setting Up Budgets
- `account_budget_setup.png` - Account budget configuration dialog
- `account_budget_trendline.png` - Budget visualization after setup
- `create_custom_budget_dialog.png` - Custom budget creation interface
- `custom_budget_resources.png` - Adding resources to custom budget
- `custom_budget_tile.png` - Custom budget tile in Budgets view
- `custom_budget_details.png` - Detailed view of custom budget
- `budget_email_notification.png` - Example budget alert email

#### Phase 3: Access Control
- `accountadmin_budgets_view.png` - What ACCOUNTADMIN sees
- `non_admin_no_access.png` - What non-admin users see without roles
- `account_budget_monitor_view.png` - View with ACCOUNT_BUDGET_MONITOR role
- `custom_budget_monitor_view.png` - View with CUSTOM_BUDGET_MONITOR role

#### Phase 4: Cleanup
- `drop_budget_ui.png` - Dropping budget via Snowsight UI
- `budgets_after_cleanup.png` - Budgets view after cleanup

### Diagrams

#### Workflow Diagrams
- `budget_setup_workflow.png` - Step-by-step budget setup process
- `role_hierarchy_diagram.png` - RBAC structure for budget access

#### Conceptual Diagrams
- `budget_vs_resource_monitor.png` - Comparison of budgets and resource monitors
- `custom_budget_allocation.png` - Example of departmental budget allocation
- `resource_movement_diagram.png` - Visualization of resource moving between budgets

## Image Guidelines

### Technical Specifications
- **Format:** PNG (preferred) or JPEG
- **Resolution:** Minimum 1920x1080 for screenshots
- **Color Mode:** RGB
- **File Size:** Optimize to < 500KB per image (use compression)

### Screenshot Guidelines
1. **Clean Interface:** Close unnecessary tabs and notifications
2. **Highlight Key Areas:** Use red boxes or arrows to draw attention
3. **Redact Sensitive Info:** Remove account IDs, real emails, company names
4. **Consistent Theme:** Use Snowflake's light or dark theme consistently
5. **High Contrast:** Ensure text is readable at various sizes

### Architecture Diagram Guidelines
1. Use Snowflake's official colors and icons
2. Keep design clean and professional
3. Label all components clearly
4. Show data flow with arrows
5. Include legend if needed

## Creating Screenshots

### Recommended Tools
- **macOS:** Screenshot (Cmd+Shift+4), Annotate with Preview
- **Windows:** Snipping Tool, Snip & Sketch
- **Annotation:** Microsoft PowerPoint, Google Slides, or dedicated tools like Skitch
- **Image Optimization:** TinyPNG, ImageOptim, or similar

### Best Practices
1. Take screenshots at actual size (100% zoom)
2. Capture full dialog boxes including buttons
3. Show context (include surrounding UI elements)
4. Use consistent window sizes across screenshots
5. Annotate after taking screenshot (don't rely on UI tooltips)

## Image Usage in Documentation

### Markdown Syntax
```markdown
![Alt Text Description](image/filename.png)
```

### Example
```markdown
![Account Budget Setup Dialog](image/account_budget_setup.png)
```

### Accessibility
- Always include descriptive alt text
- Alt text should describe the image content for screen readers
- Keep alt text concise but informative

## Placeholder Images

If actual screenshots are not yet available, you can use placeholder services:
- https://via.placeholder.com/1920x1080.png?text=Screenshot+Placeholder
- Replace with actual screenshots before production use

## License and Attribution

- **Snowflake Screenshots:** Property of Snowflake Inc., used for educational purposes
- **Custom Diagrams:** Created by Solutions Engineering team
- **Icons:** Snowflake brand guidelines and approved icon sets

## Maintenance

- Review screenshots quarterly for UI changes
- Update images when Snowflake releases major UI updates
- Keep backup copies of editable diagrams (PPT, Sketch, Figma files)

---

**Note to Contributors:**
When adding new images to this directory, please:
1. Use descriptive, consistent filenames (snake_case)
2. Update this README with the new image description
3. Optimize file size before committing
4. Verify images display correctly in both light and dark modes
5. Test that markdown references work correctly

For questions about image requirements, contact the Solutions Engineering team.

