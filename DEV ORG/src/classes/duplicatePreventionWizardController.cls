public class duplicatePreventionWizardController {
/*
field keeps id of the selected matched record, (field is set by JavaScript code handling ON_OPEN
event)
*/
private String matchedRecordId;
/*
next two fields keep values of FIRST_NAME and LAST_NAME fields of the imported matched record
(fields are set by JavaScript code handling ON_OPEN event)
*/
private String importedFirstName;
private String importedLastName;
// reference to the standard Contact controller
private ApexPages.StandardController stdController;
public duplicatePreventionWizardController(ApexPages.StandardController stdController) {
this.stdController = stdController;
}
// returns reference to the first wizard's page, used to control navigation
public PageReference returnToEdit() {
return Page.NewContact_Step1;
}
// returns reference to the second wizard's page, used to control navigation
public PageReference searchForDuplicates() {
return Page.NewContact_Step2;
}
// generate search criteria string needed to build URL invoking Duplicate Prevention control
public String getMatchParametersString() {
// get data entered by user
Contact contact = (Contact)stdController.getRecord();
String firstname = contact.FirstName != null ? contact.FirstName : '';String lastname = contact.LastName != null ? contact.LastName : '';
// construct full name used for matching as FirstName + LastName
String fullName = firstname + ' ' + lastname;
// values of IDC parameters should be double encoded
fullName = doubleEncode(fullName);
// search criteria should be passed in format 'mc.<match column name>:<match column
//value>' (Customer_Name is name of match column configured in Hub)
String matchParameters = 'mc.Customer_Name:' + fullName;
return matchParameters;
}
// function implements double encoding for IDC parameters
private String doubleEncode(String str) {
return EncodingUtil.urlEncode(EncodingUtil.urlEncode(str, 'UTF-8'), 'UTF-8');
}
// open selected matched record
public PageReference openMatch() {
try {
// try to find Contact using id passed in ON_OPEN event and redirect to the Contact view page
Contact matchedContact = [select id from Contact where id = :matchedRecordId];
PageReference matchViewPage = new ApexPages.StandardController(matchedContact).view();
matchViewPage.setRedirect(true);
return matchViewPage;
} catch (Exception e) {
ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.FATAL, 'Failed to load object with id ' + matchedRecordId);
ApexPages.addMessage(message);
return null;
}
}
// import selected matched record
public PageReference importObject() {
try {
// try to create Contact using data passed in ON_IMPORT event and redirect to the Contact view page
Contact importedContact = new Contact(FirstName = importedFirstName, LastName =
importedLastName);
insert importedContact;
PageReference importedViewPage = new ApexPages.StandardController(importedContact).view();
importedViewPage.setRedirect(true);
return importedViewPage;
} catch (Exception e) {
ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.FATAL, 'Failed to save object');
ApexPages.addMessage(message);
return null;
}
}
// getters and setters required to access controller's attributes using <apex:param> tag
public String getMatchedRecordId() {
return matchedRecordId;
}
public void setMatchedRecordId(String matchedRecordId) {
this.matchedRecordId = matchedRecordId;
}
public void setImportedFirstName(String value) {
importedFirstName = value;
}
public String getImportedFirstName() {
return importedFirstName;
}
public void setImportedLastName(String value) {
importedLastName = value;
}
public String getImportedLastName() {
return importedLastName;
}
}