global with sharing class SliderClass
{       
    public List<MyDS> lst_Account {get; set;}
    public List<Account__c> lst_Account1 {get; set;} 
    public Integer count {get;set;}
    global static MyDS my {get;set;}
    global static string acctName {get;set;}
    global static Map<integer,string> mapAccName;
    global static Boolean sliderUsed {get;set;}
   
    public SliderClass ()
    {
        Integer i;   
        sliderUsed = false; 
        System.Debug('\n ######## SlideContoller Constructr sliderUsed  ######### ['+sliderUsed+']');     
        lst_Account1 =   [Select Name, Account_Owner_Name__c from Account__c order by Name limit 4];      
        count = lst_Account1.size();
        i=count;
        System.debug('\n ... AAA');
        lst_Account = new List<MyDS>{};
        System.debug('\n ... AFTER');
         
    
        for(Account__c l:lst_Account1)
        {
            MyDS m = new MyDS();
            m.Name  = l.Name;
            m.Owner = l.Account_Owner_Name__c;
            m.sno = i;
            
            System.debug('\n ... BEFORE');
            lst_Account.add(m);
            i--;
        }
        
        System.Debug('\n ######## Total Accounts '+lst_Account.size());     
                     
    }
    
    
    
    @RemoteAction
    global static Account__c getData(Integer sno)
    {
        System.Debug('\n ######## 1.  sliderUsed  ######### ['+sliderUsed+']'); 
        
        sliderUsed = false;
        
        List<Account__c> lst_Account2 = [Select Name from Account__c order by Name limit 4]; 
           
        Integer counter = lst_Account2.size();
        
        mapAccName  =   new Map<integer,string>();
        
        for(Account__c l:lst_Account2)
        {
            mapAccName.put(counter, l.Name);
            
            counter--;
        } 
        
        System.Debug('\n ######## mapAccName ::  '+mapAccName);  
         
        String accName = (String) mapAccName.get(sno);
        
        System.Debug('\n ######## accName ::  '+accName+'  AND SNO ::  '+sno);   
        
        Account__c acc  =   [Select AMOUNT__C, Account_Owner_Name__c from Account__c where Name =: accName];
        
        if(acc != null){
            sliderUsed = true;
        }
        
       // acctName    = String.valueOf(acc.AMOUNT__C)+' -- '+acc.Account_Owner_Name__c;
       
       System.Debug('\n ######## 2.  sliderUsed  ######### ['+sliderUsed+']');
           
        return acc ;
    }
    
    
    
    @RemoteAction
    global static String getPicture(Integer sno)
    {
        String picName = (String)mapAccName.get(sno);
        Document doc= [select Id from Document where Name= :picName];
        String DocId=(String)doc.Id;
       // String s=ApexPages.currentPage().getHeaders().get('Host');
        //  s=s.replace('visual.force.com','');
     //  String  picName1='https://c.ap1.content.force.com/servlet/servlet.FileDownload?file='+DocId;
    // String picName1='https://'+s+'content.force.com/servlet/servlet.FileDownload?file='+DocId;
    System.Debug(' Url -> '+URL.getSalesforceBaseUrl().toExternalForm());
      String  picName1=URL.getSalesforceBaseUrl().toExternalForm()+'/servlet/servlet.FileDownload?file='+DocId;
        return picName1 ;
    }
    
    
    global class MyDS 
    {
        public String Name {get; set;}
        public String Owner {get; set;}
        public Integer sno {get; set;}
    }                  
}