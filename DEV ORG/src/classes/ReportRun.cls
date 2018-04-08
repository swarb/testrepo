public class ReportRun{  

    public static List<Id> GetFirstColIdFromReport(id reportId,string sObjectName,string autonumFldName){

        //This will be the initial filter for the report until it runs a second time.
        //the second time and on, the filter gets dynamically assigned the autonumuber related to the bottommost id on the report.
        String filterNumber = '0';
        Set<Id> conlst = new Set<Id>();
        List<Id> conlstTotal = new List<Id>();
        boolean isFirstRecIdType = true;
        //initialize numOfRow at 1. When it gets reassigned to 0, stop the while loop
        id firstconid;
        Integer numOfRows = 1;
        Integer loopCount = 0;

        Boolean manualBreak = false;

        //break loop when report stops returning results, or when told to break.
        while(numOfRows>0 && !manualBreak){
            loopCount++;                

            // Get the report metadata in order to create dynamic filter (since reports run with a maximum of 2,000 return results)
            Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
            Reports.ReportMetadata reportMd = describe.getReportMetadata();           
            Reports.ReportFilter filter = reportMd.getReportFilters()[0];
            filter.setValue(String.valueOf(filterNumber));                              

            // Run a report synchronously
            Reports.reportResults ReportResult = Reports.ReportManager.runReport(reportId, reportMd, true);
            ReportResult.getAllData();

            // Get the fact map from the report results
            Reports.ReportFactWithDetails factDetails = 
            (Reports.ReportFactWithDetails)ReportResult.getFactMap().get('T!T');

            //create a list of report rows and populate it with the result rows from fact map
            List<Reports.ReportDetailRow> reportRows = factDetails.getRows();

            numOfRows = reportRows.size();
            System.debug('Value of numOfRows: ' + numOfRows);
            //loop through each report detail row and create a campaign member

            //loop throgh row by row the get the data
            for(integer count = 0; count<numOfRows;count++){                        

                List<Reports.ReportDataCell> datacells = reportRows[count].getDataCells();
                Reports.ReportDataCell datacell = datacells[0];
                id conid;
                try{
                conid = (id)datacell.getValue();
                }catch(Exception e){
                    isFirstRecIdType=false;
                }
                if(!isFirstRecIdType)
                return new List<Id>();
                //make sure loop doesn't enter infinite loop
                if(count==0 && loopCount>1 && firstconid==conid){
                    manualBreak = true;
                    break;
                }

                //set conid to firstconid for reference in the next loop
                if(count==0){                       
                    firstconid = conid;                     
                }

                conlst.add(conid);

                //HERE's WHERE YOU SET THE FILTER TO DYNAMICALLY CHANGE (only get it when you're in the last row of the report results)
                if(count==numOfRows-1){
                   //filterNumber= [Select Record_Number_Id__c FROM Contact WHERE id= :conid].Record_Number_Id__c;
                   string querystr = 'select '+autonumFldName+' from '+sObjectName+' where id='+'\''+conid+'\'';
                   filterNumber = (string)Database.query(querystr)[0].get(autonumFldName);
                }

            }
        }
        conlstTotal.addall(conlst);
        return conlstTotal;
    }       
}