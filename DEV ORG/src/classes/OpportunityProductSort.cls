public class OpportunityProductSort{
public sObject[] lso{get;private set;}
public string redirectionurl{get;private set;}
public static string sfbaseurl{get; set;}
public OpportunityProductSort(){
sfbaseurl = ApexPages.currentpage().getparameters().get('sfurl');
redirectionurl=URL.getSalesforceBaseUrl().toExternalForm()+'/'+ApexPages.currentpage().getparameters().get('id');
String oportunityquery='select id,';
List<Schema.FieldSetMember> fields = getFields();
            String lineitemquery = '(SELECT Quantity, UnitPrice, TotalPrice,PricebookEntry.name';
            for(Integer i=0; i<fields.size();i++ ){
                Schema.FieldSetMember m = fields[i];           
                if(m.getFieldPath().equalsignorecase('Id'))
                   continue;
                   lineitemquery += ',PricebookEntry.Product2.'+m.getFieldPath();                 
            }
            
lineitemquery+=' from OpportunityLineItems order by sortorder)';
oportunityquery+=lineitemquery;
oportunityquery+=' from Opportunity where Id='+'\''+ApexPages.currentpage().getparameters().get('id')+'\'';
System.debug('oportunityquery-'+oportunityquery);
 lso=Database.query(oportunityquery)[0].getsObjects('OpportunityLineItems');
}

  public List<Schema.FieldSetMember> getFields(){
            List<Schema.FieldSetMember> fields = null;       
                fields = Schema.SObjectType.Product2.fieldSets.getMap().get('ProductFldSet').getFields();        
            return fields;
            }
           
}