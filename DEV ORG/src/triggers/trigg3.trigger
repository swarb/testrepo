trigger trigg3 on Contact (before update) {
for(Contact a:Trigger.new)
{Contact ab=new Contact(LastName='swarnava');
insert ab;
}
}