@isTest
private class ProjectRESTServiceTest {
    @testSetup static void setUp() {
        Opportunity o = new Opportunity(
            Name = 'Test Opportunity',
            DeliveryInstallationStatus__c = 'Yet to begin',
            StageName = 'Inquiry',
            CloseDate = System.today() + 365
        );
        insert o;
    }

    static testMethod void testOpportunityRestService() {
        // Act
        String response = ProjectRESTService.postProjectData(
            '12345',
            'Test Project 1',
            [SELECT Id FROM Opportunity LIMIT 1].Id,
            System.today(),
            System.today() + 30,
            1500,
            'Billed'
        );

        // Assert
        // Response
        System.assertEquals('OK', response, 'Response should be \'OK\' with no errors.');

        // Opportunity
        Opportunity o = [
            SELECT Id, DeliveryInstallationStatus__c,
                (SELECT ProjectRef__c, Name, Start_Date__c, End_Date__c, Status__c, Billable_Amount__c FROM Projects__r)
            FROM Opportunity
            LIMIT 1
        ];
        System.assertEquals('In progress', o.DeliveryInstallationStatus__c, 'Opportunity should have been updated to \'In progress\'.');

        // Project
        System.assertEquals(1, o.Projects__r.size(), 'Only 1 Project created.');
        Project__c assertProject = o.Projects__r[0];
        System.assertEquals('12345', assertProject.ProjectRef__c);
        System.assertEquals('Test Project 1', assertProject.Name);
        System.assertEquals(System.today(), assertProject.Start_Date__c);
        System.assertEquals(System.today() + 30, assertProject.End_Date__c);
        System.assertEquals(1500, assertProject.Billable_Amount__c);
        System.assertEquals('Billed', assertProject.Status__c);
    }

    static testMethod void testOpportunityRestServiceERROR() {
        // Act
        String response = ProjectRESTService.postProjectData(
            '12345',
            'Test Project 1',
            null,
            System.today(),
            System.today() + 30,
            1500,
            'Billed'
        );

        // Assert
        // Response
        System.assertNotEquals('OK', response, 'Response contain an error.');
    }
}