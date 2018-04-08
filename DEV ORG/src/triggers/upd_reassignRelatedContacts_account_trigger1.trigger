trigger upd_reassignRelatedContacts_account_trigger1 on Account (after update) 
 {
   try {
      Set<Id> accountIds = new Set<Id>(); //set for holding the Ids of all Accounts that have been assigned to new Owners      
      Map<Id, list<contact>> acctsWithcontacts = new Map<Id, list<contact>>(); //Map for holding the Account Id with related contacts

      for (Account a : Trigger.new)  //for all records
      {
      if (a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId) 
      {            
        accountIds.add(a.Id); //add the Account Id to the set          
      }
      }
   //will hold contacts for update
      List<Contact> contact_list=[SELECT Id,AccountId,OwnerId FROM Contact where AccountId IN :accountIds];
      for(Contact c:contact_list)
      {
      if(acctsWithcontacts.get(c.AccountId)!=null)
      {
        acctsWithcontacts.get(c.AccountId).add(c);
      }
      else
      {
        acctsWithcontacts.put(c.AccountId,new List<Contact>{c});
      }
      }
      for(Id i:acctsWithcontacts.keySet())
      {
      list<contact> contact_list_updated = acctsWithcontacts.get(i);
      for(Contact c:contact_list_updated) //updating contacts associated with that account
      {
        c.OwnerId=Trigger.newMap.get(i).ownerId;

      }
      }
      update contact_list;
      }catch(Exception e)  //catch errors
      {
      System.Debug('upd_reassignRelatedContacts_account_trigger  failure: '+e.getMessage()); //write error to the debug log
      }
 }