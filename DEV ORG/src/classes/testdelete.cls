public class testdelete{

public pagereference getdodelete(){
pari__c p = [select Id from pari__c where id = 'a0A90000006SNEY'];
delete p;
return null;
}

}