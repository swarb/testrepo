public class ContactExtention{
    final Contact con;
    public OpportunityContactRole[] opcr{get;private set;}
    public AccountContactRole[] acccr{get;private set;}
    public ContactExtention(ApexPages.StandardController stdController) {
        this.con = (Contact)stdController.getRecord();
        Id id= this.con.Id;
        system.debug('id-->'+id);
        opcr = [select Opportunity.Name,Role,IsPrimary from OpportunityContactRole where ContactId=:id];
        acccr = [select Account.Name,Role,IsPrimary from AccountContactRole where ContactId=:id];
    }


}