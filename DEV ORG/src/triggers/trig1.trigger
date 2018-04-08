trigger trig1 on exam__c (before update) {
    System.debug('executed trigg1');
    List<exam__c> ex=new List<exam__c>();
    //for(exam__c exc:Trigger.new)
   // {
        
        ex.addall([select Id from exam__c where id=:Trigger.newmap.keyset()]);
       // ex.add(c);
   // }
    update ex;
}