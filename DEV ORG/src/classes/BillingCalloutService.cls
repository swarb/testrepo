public class BillingCalloutService {
    @future(callout=true)
    public static void callBillingService(String projectRef, Decimal amount) {
        BillingServiceProxy.project project = new BillingServiceProxy.project();
        project.projectRef = projectRef;
        project.billAmount = amount;
        project.username = ServiceCredentials__c.getInstance('BillingServiceCredential').Username__c;
        project.password = ServiceCredentials__c.getInstance('BillingServiceCredential').Password__c;

        BillingServiceProxy.InvoicesPortSoap11 invoices = new BillingServiceProxy.InvoicesPortSoap11();

        String response = invoices.billProject(project);

        if (response == 'OK') {
            Project__c updateProject = [SELECT Status__c FROM Project__c WHERE ProjectRef__c = :projectRef];
            if (updateProject != null) {
                updateProject.Status__c = 'Billed';
                upsert updateProject;
            }
        }
    }
}