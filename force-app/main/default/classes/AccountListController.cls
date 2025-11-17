public with sharing class AccountListController {
    public List<AccountWrapper> accounts { get; private set; }

    public AccountListController() {
        // Query accounts with opportunity count
        accounts = new List<AccountWrapper>();
        for (Account acc : [SELECT Id, Name, Industry, (SELECT Id FROM Opportunities) FROM Account LIMIT 100]) {
            accounts.add(new AccountWrapper(acc));
        }
    }

    public class AccountWrapper {
        public String Name { get; set; }
        public String Industry { get; set; }
        public Integer OpportunityCount { get; set; }

        public AccountWrapper(Account acc) {
            this.Name = acc.Name;
            this.Industry = acc.Industry != null ? acc.Industry : 'N/A';
            this.OpportunityCount = acc.Opportunities != null ? acc.Opportunities.size() : 0;
        }
    }
}