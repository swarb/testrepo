public class opportunityList2Con {
    // ApexPages.StandardSetController must be instantiated 
    
    // for standard list controllers 
    
    public Integer c{get;set;}
    public String getintialize()
    {
   // c=setCon.getResultSize()/5+1;
    c=(Integer)Math.ceil((Decimal)setCon.getResultSize()/5);
    return '<html><div><div>abcd</div></div></html>';
    }
    
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name, CloseDate FROM Opportunity]));
            }
            setCon.setPageSize(5);
            
            return setCon;
        }
        set;
    }
    public void first() {
    getintialize();
            setCon.first();
        }
      
        public void last() {
        Integer b=setCon.getResultSize();
        System.debug('getresultsize-->'+b);
        
        
            setCon.last();
        }
      
        public void previous() {
        
            setCon.previous();
        }
      
        public void next() {
        
            setCon.next();
        }
        
        public void gotopage() {
        
            setCon.setpageNumber(Integer.valueof(Apexpages.currentPage().getParameters().get('pagename')));
        
        }
        
         public Boolean hasNext {
            get {
                return setCon.getHasNext();
            }
            set;
        }
        public Boolean hasPrevious {
            get {
                return setCon.getHasPrevious();
            }
            set;
}
      public Integer pagenumber{
      get{
      return setcon.getPageNumber();
      }
      set;
      }

    // Initialize setCon and return a list of records 
    
    public List<Opportunity> getOpportunities() {
        return (List<Opportunity>) setCon.getRecords();
    }
}