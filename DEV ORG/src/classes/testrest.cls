@RestResource(urlMapping='/swarnava/*')
global with sharing class testrest{
@HttpPut
global static void insertfile(String Name,String parentid)
{
Blob file=RestContext.request.requestBody;

Attachment at=new Attachment();
at.body=file;
at.ParentId=parentid;
at.Name=Name;
insert at;
}

}