trigger trigg4 on swar__c (after delete) 
{for(swar__c a:Trigger.old)
{swar__c ab=new swar__c(Ac__c=a.Ac__c,indian_currency__c=a.indian_currency__c);
try{insert ab;}catch(Exception e) {System.debug('an error occured');}
}
}