# Account Manager Dashboard (LWC)

A comprehensive "single pane of glass" Lightning Web Component that consolidates account management workflows.

## Component Structure

```
accountManagerDashboard/
├── accountManagerDashboard.html      # Template with 3 main sections
├── accountManagerDashboard.js        # Controller logic with wire adapters
├── accountManagerDashboard.css       # Responsive styling with CSS Grid
└── accountManagerDashboard.js-meta.xml # Metadata configuration
```

## Features

### 1. Account Overview (Full Width)
- Displays all accounts in responsive grid layout
- Click-through navigation to account records
- Shows industry and opportunity count per account
- Scrollable container for large datasets (max-height: 400px)

### 2. Opportunities by Stage Chart
- CSS-based horizontal bar chart (no external libraries)
- Color-coded stages with percentages
- Dynamic width calculation based on opportunity distribution
- Smooth CSS transitions (0.6s ease)

### 3. Quick Stats Panel
- Total Accounts count
- Total Opportunities count
- Open Opportunities count (excludes Closed/Lost stages)

## Technical Implementation

### Wire Adapters
```javascript
@wire(getAccountsWithOpportunities)
accounts;

@wire(getOpportunitiesByStage)
wiredOpportunities({ error, data })
```
- Reactive data binding with Lightning Data Service
- Automatic refresh on data changes
- Handler function for chart data preparation

### Computed Properties
```javascript
get totalAccounts()      // Counts accounts from wire adapter
get totalOpportunities() // Sums all opportunity counts
get openOpportunities()  // Filters out closed/lost stages
get showChart()          // Boolean for conditional rendering
```

### Methods
- `prepareChartData()` - Transforms API data into chart-ready format with percentages
- `handleAccountClick(event)` - Navigates to account detail page using NavigationMixin

### Chart Colors
6 distinct colors for visual differentiation:
- Pink (#FF6384)
- Blue (#36A2EB)
- Yellow (#FFCE56)
- Teal (#4BC0C0)
- Purple (#9966FF)
- Orange (#FF9F40)

## Styling Approach

### Layout
- **Desktop**: Full-width account grid + 2-column bottom row (chart + stats)
- **Tablet** (≤1024px): 2-column account grid + stacked chart/stats
- **Mobile** (≤768px): Single column layout

### CSS Grid Implementation
```css
.accounts-section .card-body {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 12px;
}
```

### Design Elements
- Purple gradient header (#667EEA → #764BA2)
- Card-based sections with subtle shadows
- Hover effects on interactive elements
- Smooth transitions for professional feel

## Metadata Configuration

```xml
<targets>
    <target>lightning__AppPage</target>
    <target>lightning__HomePage</target>
</targets>
```

Exposed to:
- Lightning App Pages (AccountConsoleHome)
- Lightning Home Pages (optional)

## Error Handling

- Graceful degradation with empty states
- User-friendly error messages
- Console logging for debugging
- Loading spinners during data fetch

## Performance Optimizations

1. **Cacheable Apex methods** - Reduces server calls
2. **CSS animations** - GPU-accelerated, no JavaScript
3. **No external libraries** - Faster load times, no dependencies
4. **Conditional rendering** - Only render what's needed
5. **Efficient queries** - Single query with sub-queries in Apex
