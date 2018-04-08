@isTest
private class ProjectCalloutServiceTest {
    @testSetup static void setUp() {
        Opportunity testOppty = new Opportunity(
            Name = 'Test Opportuntiy',
            Type = 'New Project',
            StageName = 'Closed Won',
            Amount = 15000,
            CloseDate = System.today() + 365
        );
        insert testOppty;

        ServiceTokens__c newToken = new ServiceTokens__c(
            Name = 'ProjectServiceToken',
            Token__c = '12345555555'
        );
        insert newToken;
    }

    static testMethod void testSuccessfulCallout() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

        // Act
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{[SELECT Id FROM Opportunity LIMIT 1].Id});
        Test.stopTest();

        // Assert
        Opportunity assertOpportunity = [SELECT StageName FROM Opportunity LIMIT 1];
        System.assertEquals('Submitted Project', assertOpportunity.StageName, 'StageName should be updated to \'Submitted Project\'');
    }

    static testMethod void testUnsuccessfulCallout() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

        // Act
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(new List<Id>{[SELECT Id FROM Opportunity LIMIT 1].Id});
        Test.stopTest();

        // Assert
        Opportunity assertOpportunity = [SELECT StageName FROM Opportunity LIMIT 1];
        System.assertEquals('Resubmit Project', assertOpportunity.StageName, 'StageName should be updated to \'Resubmit Project\'');
    }
}