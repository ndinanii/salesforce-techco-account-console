import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getAccountsWithOpportunities from '@salesforce/apex/AccountManagerController.getAccountsWithOpportunities';
import getOpportunitiesByStage from '@salesforce/apex/AccountManagerController.getOpportunitiesByStage';

export default class AccountManagerDashboard extends NavigationMixin(LightningElement) {
    @track chartLegendData = [];
    @track isLoadingAccounts = false;
    @track isLoadingOpportunities = false;
    @track opportunitiesData = [];
    
    // Chart colors
    chartColors = [
        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
    ];

    @wire(getAccountsWithOpportunities)
    accounts;

    @wire(getOpportunitiesByStage)
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunitiesData = data;
            console.log('Opportunities data received:', data);
            this.prepareChartData();
        } else if (error) {
            console.error('Error fetching opportunities:', error);
            this.opportunitiesData = [];
        }
    }

    get opportunities() {
        return { data: this.opportunitiesData };
    }

    get totalAccounts() {
        return this.accounts.data ? this.accounts.data.length : 0;
    }

    get totalOpportunities() {
        if (!this.opportunitiesData || this.opportunitiesData.length === 0) return 0;
        return this.opportunitiesData.reduce((sum, item) => sum + item.count, 0);
    }

    get openOpportunities() {
        if (!this.opportunitiesData || this.opportunitiesData.length === 0) return 0;
        const openStages = this.opportunitiesData.filter(item => 
            !item.stage.includes('Closed') && !item.stage.includes('Lost')
        );
        return openStages.reduce((sum, item) => sum + item.count, 0);
    }

    get showChart() {
        return this.opportunitiesData && this.opportunitiesData.length > 0;
    }

    prepareChartData() {
        if (!this.opportunitiesData || this.opportunitiesData.length === 0) {
            console.log('No opportunities data to display');
            this.chartLegendData = [];
            return;
        }

        const total = this.opportunitiesData.reduce((sum, item) => sum + item.count, 0);
        
        this.chartLegendData = this.opportunitiesData.map((item, index) => {
            const percentage = ((item.count / total) * 100).toFixed(1);
            return {
                stage: item.stage,
                count: item.count,
                percentage: percentage,
                color: this.chartColors[index % this.chartColors.length],
                colorStyle: `background-color: ${this.chartColors[index % this.chartColors.length]};`,
                widthStyle: `width: ${percentage}%;`
            };
        });

        console.log('Chart data prepared:', this.chartLegendData);
    }

    handleAccountClick(event) {
        const accountId = event.currentTarget.dataset.id;
        
        // Navigate to account record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accountId,
                objectApiName: 'Account',
                actionName: 'view'
            }
        });
    }
}