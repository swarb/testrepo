public class swar{

  public String getName() {
        return null;
    }
    

//public String name{set;get;}
public String external1{set;get;}
public String external2{set;get;}
public String name;
public void setname(String name){this.name=name;}
//comment
//changes made for tfs svn

    public PageReference mymethod() {
   Account a=new Account(Name=name,external__c=external1,external2__c=external2);
   
try{
insert a;}catch(Exception e){System.assertEquals(1,1,'error occured');}

        return null;
    }


}