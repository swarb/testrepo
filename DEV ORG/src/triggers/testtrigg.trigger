trigger testtrigg on Account (after update) {
List<Id> lstid=new List<Id>();
List<swar__c> lstsw=new List<swar__c>();
for(Account a:Trigger.New)
{
lstid.add(a.Id);
}
List<swar__c> lstupd=[select Id,fd1__c,Ac__c from swar__c where Ac__c in :lstid];
/*for(Integer i=0;i<lstupd.size();i++)
{lstupd[i].fd1__c=Trigger.newmap.get(lstupd[i].Ac__c).external__c;
lstsw.add(lstupd[i]);
}*/
for(swar__c sw:lstupd)
{
    sw.fd1__c=Trigger.newmap.get(sw.Ac__c).external__c;
    lstsw.add(sw);
}
update lstupd;
}