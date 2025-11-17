@isTest
private class AccountManagerControllerTest {
    
    @testSetup
    static void setup() {
        // Create test accounts
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                Industry = 'Technology'
            ));
        }
        insert accounts;
        
        // Create test opportunities
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account acc : accounts) {
            opportunities.add(new Opportunity(
                Name = 'Test Opp 1 for ' + acc.Name,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
            opportunities.add(new Opportunity(
                Name = 'Test Opp 2 for ' + acc.Name,
                AccountId = acc.Id,
                StageName = 'Qualification',
                CloseDate = Date.today().addDays(60)
            ));
        }
        insert opportunities;
    }
    
    @isTest
    static void testGetAccountsWithOpportunities() {
        Test.startTest();
        List<AccountManagerController.AccountWrapper> result = 
            AccountManagerController.getAccountsWithOpportunities();
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assertEquals(5, result.size(), 'Should return 5 accounts');
        
        for (AccountManagerController.AccountWrapper acc : result) {
            System.assertNotEquals(null, acc.Id, 'Account ID should not be null');
            System.assertNotEquals(null, acc.Name, 'Account Name should not be null');
            System.assertEquals(2, acc.opportunityCount, 'Each account should have 2 opportunities');
        }
    }
    
    @isTest
    static void testGetOpportunitiesByStage() {
        Test.startTest();
        List<AccountManagerController.OpportunityStageWrapper> result = 
            AccountManagerController.getOpportunitiesByStage();
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should not be null');
        System.assert(result.size() > 0, 'Should return at least one stage');
        
        Integer totalCount = 0;
        for (AccountManagerController.OpportunityStageWrapper stage : result) {
            System.assertNotEquals(null, stage.stage, 'Stage name should not be null');
            System.assert(stage.count > 0, 'Count should be greater than 0');
            totalCount += stage.count;
        }
        
        System.assertEquals(10, totalCount, 'Total opportunities should be 10');
    }
    
    @isTest
    static void testAccountWrapperWithNullIndustry() {
        Account testAcc = new Account(Name = 'Test Account', Industry = null);
        insert testAcc;
        
        Account queriedAcc = [SELECT Id, Name, Industry, (SELECT Id FROM Opportunities) FROM Account WHERE Id = :testAcc.Id];
        
        Test.startTest();
        AccountManagerController.AccountWrapper wrapper = new AccountManagerController.AccountWrapper(queriedAcc);
        Test.stopTest();
        
        System.assertEquals('N/A', wrapper.Industry, 'Industry should default to N/A when null');
        System.assertEquals(0, wrapper.opportunityCount, 'Opportunity count should be 0');
    }
}