# Lightning Applications

## AccountConsoleApp.app-meta.xml

The main Lightning Application that serves as the container for the Account Console solution.

### Configuration

**Form Factor**: Large (Desktop optimized)

**Navigation Type**: Standard

**Brand Color**: #667EEA (Purple gradient start)

### Navigation Items

1. **Home** (Default)
   - Custom page: `AccountConsoleHome`
   - Primary interface with dashboard component
   
2. **Accounts**
   - Standard Account object list view
   - Full CRUD operations
   
3. **Opportunities**
   - Standard Opportunity object list view
   - Pipeline management

### User Access

Controlled via:
- User Profile assignments
- Permission Sets
- App visibility settings in Setup

### Purpose

Provides Account Managers with:
- Unified workspace
- Single point of entry
- Consistent navigation
- Branded experience

### Custom Home Page

Instead of standard Lightning home page, uses custom `AccountConsoleHome` FlexiPage with the `accountManagerDashboard` component as the primary interface.
