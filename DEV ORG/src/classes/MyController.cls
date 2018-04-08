public class MyController {
public List<Opportunity> oppinfo{get;set;}
public Id selectedaccount{get;set;}
 
    public void acctclick() 
    {
     oppinfo =[select Name,Id from Opportunity where AccountId =:selectedaccount];  
    }


    public List<Account> getAcctsinfo() 
    {
    
        return [select Name,Id from Account];
        
        
    }

}