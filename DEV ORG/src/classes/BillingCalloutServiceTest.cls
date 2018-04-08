@isTest
private class BillingCalloutServiceTest {
    @testSetup static void setUpTest() {
        ServiceCredentials__c newCreds = new ServiceCredentials__c(
            Name = 'BillingServiceCredential',
            Username__c = 'test',
            Password__c = 'pass'
        );
        insert newCreds;

        Opportunity newOpp = new Opportunity(
            Name = 'Test Oppty',
            StageName = 'Inquiery',
            CloseDate = System.today() + 365
        );
        insert newOpp;

        Project__c newProject = new Project__c(
            Opportunity__c = newOpp.Id,
            Status__c = 'Running'
        );
        insert newProject;
    }

    static testMethod void testSuccessfulBillingCallout() {
        // Arrange
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Project__c newProject = [SELECT Id, Status__c FROM Project__c LIMIT 1];

        // Act
        Test.startTest();
        newProject.Status__c = 'Billable';
        update newProject;
        Test.stopTest();

        // Assert
        Project__c assertProject = [SELECT Status__c FROM Project__c WHERE Id = :newProject.Id];
        System.assertEquals('Billed', assertProject.Status__c, 'Status should be updated to \'Billed\'.');
    }

    static testMethod void testFaliedBillingCallout() {
        // Arrange
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Project__c newProject = [SELECT Id, Status__c FROM Project__c LIMIT 1];

        // Act
        Test.startTest();
        newProject.Status__c = 'Billable';
        update newProject;
        Test.stopTest();

        // Assert
        Project__c assertProject = [SELECT Status__c FROM Project__c WHERE Id = :newProject.Id];
        System.assertEquals('Billable', assertProject.Status__c, 'Status should NOT be updated to \'Billed\'.');
    }
}