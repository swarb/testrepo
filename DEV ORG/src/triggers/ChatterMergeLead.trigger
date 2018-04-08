trigger ChatterMergeLead on Lead (after delete) {
List<Lead> ldl = Trigger.old;
List<Id> ldlmerge = new List<Id>();
Id masterrecId;
for(Lead l: ldl)//{
if(l.MasterRecordId!=null)
ldlmerge.add(l.id);
if(ldlmerge.size()>0)
{
ChatterMergeUtil cmu = new ChatterMergeUtil();
cmu.chatterFeedsMerge(ldl[0].MasterRecordId,ldlmerge,null);
}
//}
}