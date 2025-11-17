# Visualforce Pages

## AccountList.page

A Visualforce page that displays a list of accounts with key details, fulfilling the assessment requirement for a Visualforce component.

### Purpose
Demonstrates proficiency in legacy Salesforce UI framework while maintaining modern design aesthetics.

### Features
- Lists all accounts (up to 100)
- Displays account name, industry, and opportunity count
- Responsive card-based layout
- Custom CSS styling (no Bootstrap dependency)
- Clean, professional appearance

### Controller
**AccountListController.cls**

Queries accounts with related opportunities:
```apex
SELECT Id, Name, Industry, (SELECT Id FROM Opportunities) 
FROM Account 
LIMIT 100
```

### Data Transformation
Uses inner wrapper class to transform data:
```apex
public class AccountWrapper {
    public String Name { get; set; }
    public String Industry { get; set; }
    public Integer OpportunityCount { get; set; }
}
```

### Styling Approach
- **Header**: Blue gradient background (#4facfe → #00f2fe)
- **Cards**: White background with hover effects
- **Badges**: Color-coded industry and opportunity indicators
- **Layout**: Responsive grid that adapts to screen size

### Design Pattern
Traditional Visualforce MVC pattern:
- **Model**: Account and Opportunity SObjects
- **View**: AccountList.page (markup)
- **Controller**: AccountListController.cls (business logic)

### Accessibility
- Semantic HTML structure
- Clear visual hierarchy
- Readable font sizes
- Sufficient color contrast

### Usage
Access via URL: `/apex/AccountList`

Can be embedded in:
- Lightning Pages (via Visualforce component)
- Classic Salesforce tabs
- Custom Lightning components
