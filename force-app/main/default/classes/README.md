# Apex Controllers

This folder contains the server-side Apex controllers that power the Account Console application.

## Controllers

### AccountManagerController.cls
**Purpose**: Main data provider for the `accountManagerDashboard` Lightning Web Component.

**Methods**:
```apex
@AuraEnabled(cacheable=true)
public static List<AccountWrapper> getAccountsWithOpportunities()
```
- Returns accounts with opportunity counts
- Uses efficient sub-query to avoid N+1 queries
- Limited to 100 records for performance
- `with sharing` enforces record-level security

```apex
@AuraEnabled(cacheable=true)
public static List<OpportunityStageWrapper> getOpportunitiesByStage()
```
- Aggregates opportunities by stage using GROUP BY
- Returns stage name and count
- Excludes deleted records
- Cacheable for Lightning Data Service optimization

**Wrapper Classes**:
- `AccountWrapper`: Transforms Account into LWC-friendly format with opportunity count
- `OpportunityStageWrapper`: Simple DTO for stage aggregation data

---

### AccountListController.cls
**Purpose**: Controller for the `AccountList` Visualforce page.

**Methods**:
```apex
public AccountListController()
```
- Constructor queries accounts with related opportunities
- Populates `accounts` property with wrapped data
- Handles null industry values with "N/A" default

**Wrapper Class**:
- `AccountWrapper`: Inner class for Visualforce data binding
- Properties: Name, Industry, OpportunityCount
- Null-safe industry handling

---

## Test Classes

### AccountManagerControllerTest.cls
**Coverage**: 100% | **Tests**: 3

**Test Methods**:
1. `testGetAccountsWithOpportunities()` - Verifies account retrieval with opportunity counts
2. `testGetOpportunitiesByStage()` - Validates stage aggregation logic
3. `testAccountWrapperWithNullIndustry()` - Ensures null-safe wrapper handling

**Test Setup**:
- 5 test accounts created
- 2 opportunities per account (10 total)
- 2 different stages (Prospecting, Qualification)

---

### AccountListControllerTest.cls
**Coverage**: 100% | **Tests**: 2

**Test Methods**:
1. `testAccountListController()` - Verifies controller initialization and data
2. `testAccountWrapperWithNullIndustry()` - Tests null industry handling

---

## Design Patterns

### Security
- All controllers use `with sharing` keyword
- SOQL queries respect user permissions
- No hardcoded user filters

### Performance
- `@AuraEnabled(cacheable=true)` enables Lightning Data Service caching
- Single queries with sub-queries (no loops)
- LIMIT clauses prevent governor limit issues

### Maintainability
- Wrapper classes separate data transformation from query logic
- Clear method naming
- Comprehensive test coverage
- Null-safe operations
