@isTest
private class AccountListControllerTest {
    
    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 3; i++) {
            accounts.add(new Account(
                Name = 'VF Test Account ' + i,
                Industry = 'Manufacturing'
            ));
        }
        insert accounts;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account acc : accounts) {
            opportunities.add(new Opportunity(
                Name = 'VF Test Opp for ' + acc.Name,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }
        insert opportunities;
    }
    
    @isTest
    static void testConstructor() {
        Test.startTest();
        AccountListController controller = new AccountListController();
        Test.stopTest();
        
        System.assertNotEquals(null, controller.accounts, 'Accounts list should not be null');
        System.assert(controller.accounts.size() > 0, 'Should have at least one account');
        
        for (AccountListController.AccountWrapper acc : controller.accounts) {
            System.assertNotEquals(null, acc.Name, 'Account name should not be null');
        }
    }
    
    @isTest
    static void testAccountWrapperWithData() {
        Account testAcc = [SELECT Id, Name, Industry, (SELECT Id FROM Opportunities) FROM Account LIMIT 1];
        
        Test.startTest();
        AccountListController.AccountWrapper wrapper = new AccountListController.AccountWrapper(testAcc);
        Test.stopTest();
        
        System.assertEquals(testAcc.Name, wrapper.Name, 'Name should match');
        System.assertEquals(testAcc.Industry, wrapper.Industry, 'Industry should match');
        System.assertEquals(1, wrapper.OpportunityCount, 'Should have 1 opportunity');
    }
}