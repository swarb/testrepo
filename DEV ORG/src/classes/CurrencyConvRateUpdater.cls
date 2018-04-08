public class CurrencyConvRateUpdater{
@future(callout=true)
public Static void updatecurr()
{
List<Conversion_Rate__c> lstconv=new List<Conversion_Rate__c>();
Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'http://openexchangerates.org/api/latest.json?app_id=834cd55a20784485b719882fdf11640c';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.        
        HttpResponse response = httpProtocol.send(request);
        //System.debug(response.getBody());
        JSONParser parser = JSON.createParser(response.getBody());
        JSONParser parser1;
        boolean isEntry=false;
        while (parser.nextToken() != null) {
            parser.nextValue();
            //if ((parser.getCurrentName()=='rates')){
                // Get the value.
                //parser.nextToken();
                // Compute the grand total price for all invoices.
                 //parser.getText();
            if(isEntry&&parser.getCurrentName()!=null&&parser.getText()!='}')
                {
                    System.debug('1st--'+parser.getCurrentName());
                    System.debug('2nd--'+parser.getDecimalValue());
                    lstconv.add(new Conversion_Rate__c(Name=parser.getCurrentName(),ConvRate__c=parser.getDecimalValue()));
                }   
                
            if(parser.getCurrentName()=='rates'&&parser.getText()=='{')
            isEntry=true;    
                // parser1 = JSON.createParser(parser.getText());
               // break;
           // }
        }
               upsert lstconv Name;
               /* while (parser1.nextToken() != null){
                //parser1.nextToken(); 
                parser.nextValue();
                System.debug(parser1.getCurrentName()+'--'+parser1.getText()); 
                  
                }*/
}
}