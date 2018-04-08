public class myControllerExtension2 {
private final Account acct;
// The extension constructor initializes the private member
// variable acct by using the getRecord method from the standard
// controller.
ApexPages.StandardController shc;
public myControllerExtension2(ApexPages.StandardController stdController) {
List<String> adr=new String[]{'external2__c'};
adr.add('external__c');
stdController.addFields(adr);
this.acct = (Account)stdController.getRecord();

shc=stdController;
}
public String getGreeting() {
return 'Hello ' + acct.external__c + ' (' + acct.id + ')';
}
public PageReference getmymethod(){return shc.edit();}
}