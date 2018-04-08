public class ProjectCalloutService {
    @InvocableMethod
    public static void postOpportunityToPMS(List<Id> oppIds) {
        Opportunity opptyToProcess = [
            SELECT Id, Name, Account.Name, CloseDate, Amount
            FROM Opportunity
            WHERE Id = :oppIds[0]
        ];

        if (opptyToProcess != null) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:ProjectService');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('token', ServiceTokens__c.getInstance('ProjectServiceToken').Token__c);
            req.setBody('' +
                '{' +
                    '"opportunityId":"' + opptyToProcess.Id + '",' +
                    '"opportunityName":"' + opptyToProcess.Name + '",' +
                    '"accountName":"' + opptyToProcess.Account.Name + '",' +
                    '"closeDate":"' + opptyToProcess.CloseDate + '",' +
                    '"amount":"' + opptyToProcess.Amount + '"' +
                '}'
            );
            HttpResponse res = h.send(req);

            if (res.getStatusCode() == 200) {
                opptyToProcess.StageName = 'Submitted Project';
            } else {
                opptyToProcess.StageName = 'Resubmit Project';
            }

            update opptyToProcess;
        }
    }

    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {
        public void execute(QueueableContext context) {
            System.enqueueJob(new ProjectCalloutService());
        }
    }
}