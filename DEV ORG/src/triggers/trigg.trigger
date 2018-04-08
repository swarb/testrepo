trigger trigg on Account (after delete) {
List<Account> acclist=new List<Account>();
for(Account a:Trigger.old)
{
Account ab=new Account(Name=a.Name,external__c=a.external__c,external2__c=a.external2__c);
acclist.add(ab);
}
insert acclist;
}