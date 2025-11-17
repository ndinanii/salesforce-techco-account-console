public with sharing class AccountManagerController {
    
    /**
     * Get accounts with opportunity counts for the dashboard
     * @return List of AccountWrapper objects with account details and opportunity counts
     */
    @AuraEnabled(cacheable=true)
    public static List<AccountWrapper> getAccountsWithOpportunities() {
        List<AccountWrapper> result = new List<AccountWrapper>();
        
        // Query accounts with related opportunities
        List<Account> accounts = [
            SELECT Id, Name, Industry, 
                   (SELECT Id FROM Opportunities)
            FROM Account 
            WHERE IsDeleted = false
            ORDER BY Name
            LIMIT 100
        ];
        
        for (Account acc : accounts) {
            result.add(new AccountWrapper(acc));
        }
        
        return result;
    }
    
    /**
     * Get opportunities grouped by stage for the chart
     * @return List of OpportunityStageWrapper objects with stage names and counts
     */
    @AuraEnabled(cacheable=true)
    public static List<OpportunityStageWrapper> getOpportunitiesByStage() {
        List<OpportunityStageWrapper> result = new List<OpportunityStageWrapper>();
        
        // Aggregate opportunities by stage
        List<AggregateResult> stageData = [
            SELECT StageName, COUNT(Id)
            FROM Opportunity
            WHERE IsDeleted = false
            GROUP BY StageName
            ORDER BY StageName
        ];
        
        for (AggregateResult ar : stageData) {
            result.add(new OpportunityStageWrapper(
                (String)ar.get('StageName'),
                (Integer)ar.get('expr0')
            ));
        }
        
        return result;
    }
    
    /**
     * Wrapper class for account data
     */
    public class AccountWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String Industry { get; set; }
        @AuraEnabled public Integer opportunityCount { get; set; }
        
        public AccountWrapper(Account acc) {
            this.Id = acc.Id;
            this.Name = acc.Name;
            this.Industry = acc.Industry != null ? acc.Industry : 'N/A';
            this.opportunityCount = acc.Opportunities != null ? acc.Opportunities.size() : 0;
        }
    }
    
    /**
     * Wrapper class for opportunity stage data
     */
    public class OpportunityStageWrapper {
        @AuraEnabled public String stage { get; set; }
        @AuraEnabled public Integer count { get; set; }
        
        public OpportunityStageWrapper(String stage, Integer count) {
            this.stage = stage;
            this.count = count;
        }
    }
}