public class CSVFileUploader 
{
    public string FileName{get;set;}
    public string filecontentinstring;
    public transient Blob contentFile{get;set;}
    List<String> filelines = new List<String>{};   //this list of string hold csv data with each line as one string
    public Pagereference ReadFile()
    {   
     try{
        System.debug('file name--'+FileName);
        if(!FileName.endsWithIgnoreCase('.csv'))
        {System.debug('not csv');throw new FileException('Please Upload a csv File');}
        filecontentinstring=contentFile.toString();
        filelines = filecontentinstring.split('\n');
        for (Integer i=0;i<filelines.size();i++) //make variable i=1 if you dont want header into your data
            {
               System.debug(filelines[i]);
            }  
        } catch(Exception e)
            {
                ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.FATAL,e.getmessage());
                ApexPages.addMessage(errormsg);
            }
        return null; 
     }
     public class FileException extends Exception{}
     
     private static testmethod void testfile(){
     CSVFileUploader cfu= new CSVFileUploader();
     cfu.FileName = 'abcd.csv';
     cfu.contentFile=Blob.valueOf('col1,col2,col3');
     cfu.ReadFile();
     System.assert(cfu.filelines[0]=='col1,col2,col3');
     cfu.FileName = 'abcd.jpeg';
     cfu.ReadFile();
     }
}