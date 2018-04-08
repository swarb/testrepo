@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(
        String ProjectRef,
        String ProjectName,
        String OpportunityId,
        Date StartDate,
        Date EndDate,
        Double Amount,
        String Status
    ) {
        String response = '';
        Project__c projectToUpsert = new Project__c(
            ProjectRef__c = ProjectRef,
            Name = ProjectName,
            Opportunity__c = OpportunityId,
            Start_Date__c = StartDate,
            End_Date__c = EndDate,
            Billable_Amount__c = Amount,
            Status__c = Status
        );

        Savepoint sp = Database.setSavepoint();

        try {
            upsert projectToUpsert ProjectRef__c;

            Opportunity o = new Opportunity(
                Id = OpportunityId,
                DeliveryInstallationStatus__c = 'In progress'
            );
            update o;

            response = 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            response = e.getMessage();
        }

        return response;
    }
}