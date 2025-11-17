# Lightning FlexiPages

## AccountConsoleHome.flexipage-meta.xml

Custom Lightning App Page that serves as the home page for the Account Console application.

### Configuration

**Type**: AppPage

**Template**: `flexipage:defaultAppHomeTemplate`

**Master Label**: Account Console Home

### Component Placement

**Main Region**:
- Component: `accountManagerDashboard`
- Identifier: `c_accountManagerDashboard`

### Purpose

Embeds the custom LWC dashboard as the primary interface when users open the Account Console app, replacing the standard Salesforce home page.

### How It Works

1. User clicks Account Console in App Launcher
2. Salesforce loads AccountConsoleApp
3. App's default tab (Home) references this FlexiPage
4. FlexiPage renders accountManagerDashboard component
5. User sees "single pane of glass" dashboard

### Integration Point

This FlexiPage is the bridge between:
- Lightning Application (container)
- Lightning Web Component (content)

### Assignment

Automatically displayed to users who have access to the Account Console app. No additional activation required.
