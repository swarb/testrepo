trigger mytrigg on Contact (after delete) {
for(Contact a:Trigger.old)
{System.debug(a);
Contact ab=new Contact(LastName=a.LastName,FirstName=a.FirstName,Account=a.Account);

insert ab;
}
}