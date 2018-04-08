@RestResource(urlMapping='/UserPerm/*')
    global class GetParentId {

    @HttpGet
    global static ReturnClass doGetParentId() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    Id recId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    Schema.SObjectType sobjtyp = recId.getSObjectType();
    string objname = string.valueof(sobjtyp);
    ReturnClass rc = new ReturnClass();
    rc.sobjectname = objname;
    boolean iscustom = objname.contains('__c');
    boolean ischildobj=false;
    try{
        database.query('select Id,OwnerId from '+objname+' limit 1');
       }catch(queryException e)
    {
        ischildobj=true;
    }
    if(ischildobj)
    {
        rc.IsOwdPublic = false;
        
    }
    else
    {
        rc.IsOwdPublic = true;
        rc.ParentId=null;
        return rc;
    }
    ParentObjectIdentifier__c poif = ParentObjectIdentifier__c.getValues(string.valueof(sobjtyp));
    if(poif==null) 
    {
        rc.ParentId=null;
        return rc;
    }    
    string querystr = 'select Id,'+poif.MasterDetail_Field__c+' from '+objname+' where Id='+'\''+recId+'\'';
    System.debug(querystr);
    sObject so = database.query(querystr);    
    
    rc.ParentId = (Id)so.get(poif.MasterDetail_Field__c);
    return rc;
    }
    
    public static boolean getCustomOWD(String objName){    
    Boolean error = false;
    // Use global describe to check if Sobject exists with name provided
    // if no, then OWD is public r,w
    // if yes, then a generalised version of 
    try{
      sObject[] so= database.query('SELECT Id,ParentId,UserOrGroupId,RowCause,AccessLevel FROM '+objName+'__Share');
    }
    catch(QueryException ex){
        // check the exception contents here to see if OWD is public r
        error = true;
    }
    
    //if( !error)
    // OWD is private;    
    return error;

    
}
 public static boolean getStandardOWD(String objName){  
 sObject o;
 if(objName.equalsignorecase('Pricebook') || objName.equalsignorecase('OpportunityAccess') || objName.equalsignorecase('Lead') || objName.equalsignorecase('Contact') || objName.equalsignorecase('Case') || objName.equalsignorecase('Campaign') || objName.equalsignorecase('Calendar') || objName.equalsignorecase('Account'))
  o = [Select  DefaultPricebookAccess, DefaultOpportunityAccess, DefaultLocaleSidKey, DefaultLeadAccess, DefaultContactAccess, DefaultCaseAccess, DefaultCampaignAccess, DefaultCalendarAccess, DefaultAccountAccess, CreatedDate
 From Organization];
  
  if(o!=null && o.get('Default'+objName+'Access')=='All')
  return true;
  else return false;
 
 }
    
    global class ReturnClass{
    
    Id ParentId;   
    boolean IsOwdPublic;
    String sobjectname;
    }
    }