global class SearchAndReplace implements Database.Batchable<sObject>,Database.AllowsCallouts{

   global  String Query;
   global final String SessionId;  
   global Integer numrecinbatch;
   
  
   global  Integer getnumofrec(String Query)
   {           
        Query='SELECT COUNT(Id) '+query.substring(query.indexOfIgnoreCase('from'));   
        Query=Query.replace(' ','+');
        System.debug('query-->'+Query);
        Http httpProtocol = new Http();
        HttpRequest request = new HttpRequest();
     
        // Set the endpoint URL.
        String endpoint = URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v28.0/query/?q='+Query;
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        System.debug('session->'+UserInfo.getSessionId());
        
       
        request.setHeader('Authorization','OAuth ' + this.SessionId);
        HttpResponse response = httpProtocol.send(request);
        //System.debug(response.getBody());
        JSONParser parser = JSON.createParser(response.getBody());
        while (parser.nextToken() != null) {
            parser.nextValue();
            System.debug(parser.getCurrentName());
            if(parser.getCurrentName()=='expr0')
            {
                System.debug('Total Num of Rec--'+parser.getDecimalValue());
                break;
            }
                
        }
        return (Integer)parser.getDecimalValue();
   }

   global SearchAndReplace(String q, String e){

      Query=q; SessionId=e; 
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
   Database.querylocator dq=Database.getQueryLocator(query);
   //ApexPages.StandardSetController ctl=new ApexPages.StandardSetController(dq);
   //numrecinbatch=ctl.getResultSize();
   numrecinbatch=getnumofrec(Query);
      return dq;
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
    /* for(sobject s : scope){
     s.put(Field,Value); 
     }
     update scope;*/
    }

   global void finish(Database.BatchableContext BC){
   }
}