trigger ProjectTrigger on Project__c (after update) {
    //Call the Billing Service callout logic here
    for (SObject sob : Trigger.new) {
        Project__c project = (Project__c) sob;

        if (Trigger.oldMap.get(project.Id).get('Status__c') != 'Billable' && project.Status__c == 'Billable') {
            BillingCalloutService.callBillingService(project.ProjectRef__c, project.Billable_Amount__c);
        }
    }
}