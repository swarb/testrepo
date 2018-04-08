public class Leadmerge1{
public static void chatterFeedsMerge(Id targetObjectId, LIST<Id> margeObjectIDs, Id mergeResultParentId){
Schema.DescribeSObjectResult descResult = Lead.SObjectType.getDescribe();
Map<String, Schema.SObjectField> fldMap = descResult.fields.getMap();
//Update Chatter Feed
List<FeedItem> feedtobeinserted=new List<FeedItem>();
FeedItem tmp;
List<FeedComment> fdcom=new List<FeedComment>();
List<FeedLike> fdLike=new List<FeedLike>();
Map<Id,Integer> feedmap=new Map<Id,Integer>();
Integer i=0;
//List<FeedItem> lstfeed=[select Id,Title,LinkUrl,LikeCount,Type,Body,CommentCount,ContentType,ContentSize,ContentFileName,ContentDescription,ContentData,ParentId,(select FeedItemId,FeedEntityId from FeedLikes),(select FeedItemId,CommentBody from FeedComments) from FeedItem where ParentId In:SecLeadIds AND (Type !='TrackedChange' AND Type !='UserStatus')];
for(FeedItem fi:[select Id,CreatedDate,Title,LinkUrl,LikeCount,Type,Body,CommentCount,CreatedBy.FirstName,CreatedBy.LastName,ContentType,ContentSize,ContentFileName,ContentDescription,ContentData,ParentId,Visibility,InsertedById,(select FeedItemId,FeedEntityId,createdById,InsertedById,CreatedDate from FeedLikes),(select FeedItemId,CommentBody,InsertedById,CreatedDate from FeedComments),(SELECT ID, FieldName, OldValue, NewValue from FeedTrackedChanges) from FeedItem where ParentId In:margeObjectIDs ORDER BY CreatedDate desc])
{
System.debug(fi);
tmp=fi.clone();
tmp.ParentId=targetObjectId;
tmp.CreatedById=fi.InsertedById;
tmp.CreatedDate=fi.CreatedDate;
if(fi.Type =='TrackedChange')
{tmp.Type='TextPost';
tmp.body=fi.CreatedBy.FirstName+' '+fi.CreatedBy.LastName+' changed '+fldMap.get(fi.FeedTrackedChanges[0].FieldName.replace('Lead.','')).getDescribe().getLabel()+' from '+(fi.FeedTrackedChanges[0].OldValue==null?'a blank value':fi.FeedTrackedChanges[0].OldValue)+' to '+(fi.FeedTrackedChanges[0].NewValue==null?'a blank value':fi.FeedTrackedChanges[0].NewValue);
}
feedtobeinserted.add(tmp);
feedmap.put(fi.Id,i);
for(Integer k=0;k<fi.CommentCount;k++)
    fdcom.add(fi.FeedComments[k]);
    for(Integer k=0;k<fi.LikeCount;k++)
    fdLike.add(fi.FeedLikes[k]); 
i++;       
}
Database.SaveResult[] sr=Database.insert(feedtobeinserted,false);
for(Database.SaveResult ds:sr)
System.debug('swar-'+ds.errors);
//adding feedcomments

//Map<Id,Integer> feedmap=new Map<Id,Integer>();
//for(Integer i=0;i<lstfeed.size();i++)
//feedmap.put(lstfeed[i].Id,i);
//List<FeedComment> fdcom=new List<FeedComment>();
/*for(FeedItem fi:lstfeed)
{
    //FeedComment[] tmpfeedComment=fi.FeedComments;
    //fdcom.addAll(tmpfeedComment);
    //for(Integer k=0;k<fi.CommentCount;k++)
    //fdcom.add(fi.FeedComments[k]);
}*/
FeedComment tmpcom;
List<FeedComment> feedcomtobeinserted=new List<FeedComment>();
Map<Id,Integer> commentlike=new Map<Id,Integer>();
for(Integer j=0;j<fdcom.size();j++)
{
tmpcom=fdcom[j].clone();
commentlike.put(fdcom[j].Id,j);
System.debug('testdebug-->'+fdcom[j].FeedItemId);
System.debug(feedmap.keySet());
tmpcom.FeedItemId=sr.get(feedmap.get(fdcom[j].FeedItemId)).Id;
tmpcom.createdById=fdcom[j].InsertedById;
tmpcom.CreatedDate=fdcom[j].CreatedDate;
feedcomtobeinserted.add(tmpcom);
}
insert feedcomtobeinserted;

//adding feedLikes

FeedLike tmpLike;
//List<FeedLike> fdLike=new List<FeedLike>();
/*for(FeedItem fi:lstfeed)
{
    //FeedLike[] tmplstfeedlike=fi.FeedLikes;
    //fdLike.addAll(tmplstfeedlike);
   // for(Integer k=0;k<fi.LikeCount;k++)
   // fdLike.add(fi.FeedLikes[k]);
}*/
List<FeedLike> feedLiketobeinserted=new List<FeedLike>();
for(Integer j=0;j<fdLike.size();j++)
{
tmpLike=fdLike[j].clone();
tmpLike.FeedItemId=sr.get(feedmap.get(fdLike[j].FeedItemId)).Id;
tmpLike.FeedEntityId=tmpLike.FeedItemId;
tmpLike.createdById=fdLike[j].InsertedById;
tmpLike.createdDate=fdLike[j].createdDate;
feedLiketobeinserted.add(tmpLike);
}
System.debug(feedLiketobeinserted);
for(Integer j=0;j<fdcom.size();j++)
{
    for(ConnectApi.ChatterLike l: ConnectApi.ChatterFeeds.getLikesForComment(null,fdcom[j].Id).likes)
    {   FeedLike fl=new FeedLike();
        fl.createdById=l.user.Id;
        fl.FeedEntityId=feedcomtobeinserted.get(commentlike.get(fdcom[j].Id)).Id;
        fl.FeedItemId=sr.get(feedmap.get(fdcom[j].FeedItemId)).Id;
        feedLiketobeinserted.add(fl);
    }
}
insert feedLiketobeinserted;
List<Id> subscription_main_record=new List<Id>();
List<EntitySubscription> lst_followers_to_be_inserted=new List<EntitySubscription>();
for(EntitySubscription es:[select SubscriberId from EntitySubscription where ParentId=:targetObjectId])
subscription_main_record.add(es.SubscriberId);
List<AggregateResult> followers=[select SubscriberId from EntitySubscription where (ParentId IN:margeObjectIDs AND SubscriberId NOT IN :subscription_main_record) group by SubscriberId];
for(AggregateResult fl:followers)
{
    EntitySubscription tmpes=new EntitySubscription(ParentId=targetObjectId,SubscriberId=String.valueOf(fl.get('SubscriberId')));
    lst_followers_to_be_inserted.add(tmpes);
}
    insert lst_followers_to_be_inserted;
}
}