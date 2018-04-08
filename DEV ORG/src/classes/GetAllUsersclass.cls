public class GetAllUsersclass{

public static string getSharePageContent(Id recid,integer pageno){
    string strSessionID = UserInfo.getSessionId();
    String requestUrl =   URL.getSalesforceBaseUrl().toExternalForm()+'/00Oi0000004tVdn?csv=1';        
    HttpRequest req = new HttpRequest();
    req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/p/share/SharingBlowoutPage/d?parentId='+recid+'&lsr='+pageno*25);
    req.setMethod('GET');
    req.setHeader('Cookie','sid=' + strSessionID );
    req.setHeader('Authorization','OAuth ' + strSessionID );
    Blob output = new Http().send(req).getBodyAsBlob() ;
    //System.debug('output-->'+output.toString());

    return output.toString();
}

public static List<String> getAllUsers(Id recid){
    List<String> luids = new List<String>();
    Integer prevluidssize,pageno=0;
    do{
    prevluidssize = luids.size();
    String PageContent=getSharePageContent(recid,pageno);//this returns content sharing page according to pageno
    Integer i=0,j=0,counter=0;
    while(counter++<25){
    i=PageContent.indexOf('Why? - Record',j);
    if(i==-1)
    break;
    j=PageContent.indexOf('/005',i);//oo5 is user id prefix for all organizations
    String uid=PageContent.substring((j+1),(j+16));
    luids.add(uid);
    }
    pageno++;
    }while(prevluidssize<luids.size());
    return luids;

}
}