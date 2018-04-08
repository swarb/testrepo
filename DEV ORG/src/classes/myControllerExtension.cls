public class myControllerExtension {
private final Account acct;
// The extension constructor initializes the private member
// variable acct by using the getRecord method from the standard
// controller.
ApexPages.StandardController shc;
public myControllerExtension(ApexPages.StandardController stdController) {
this.acct = (Account)stdController.getRecord();
shc=stdController;
}
public String getGreeting() {
return 'Hello ' + acct.name + ' (' + acct.id + ')';
}
public PageReference getmymethod(){return shc.cancel();}
}