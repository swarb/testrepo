public class customset{
//public string b{set;get;}
public string a{get;set;}
public void foo()
{//if(b!=null)
 String c=ApexPages.currentPage().getParameters().get('name');
if(c!=null || c!=''){
MAP<String,newobj__c> var1=newobj__c.getAll();
a= var1.get(c).cust_field__c;

}
}
}