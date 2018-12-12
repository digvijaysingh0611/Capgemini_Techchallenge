public class AccountControllerClass {
    
    @AuraEnabled
    Public static List<Case> getAccList(){
        
        List<Case> caselist = [SELECT Id,CaseNumber,Origin,Subject,Status,Priority,Reason,ContactEmail FROM Case  ORDER BY CaseNumber DESC LIMIT 10];
        return caselist; 
		
    }
    @Auraenabled
    public static List<Case> delteAccountById(String accid)
    {
        
        Case delAccount=[Select Id from Case where id=:accid];
        delete delAccount;
        return [Select Id,CaseNumber,Subject,Status,Priority from Case LIMIT 10 ];
    }
    
    @Auraenabled
    public static Case EditCaseById(String editid){
      
        Case editCase = [Select Id,Origin,Subject,Status,Priority,Reason,ContactEmail from Case where id =:editid];
        return editCase;
        
    }
    @Auraenabled
    public static  List<Case> SaveCaseById(String subject,String status,String priority,String editid,String reason){
        Case caseSave = new Case();
        caseSave.Subject= subject;
        caseSave.Status= status;
        caseSave.Priority=priority;
        caseSave.id= editid;
        caseSave.Reason= reason;
        
        upsert caseSave;
       
        
        return [Select Id,CaseNumber,Subject,Status,Priority,reason from Case LIMIT 10 ];
       
        
    }
     @Auraenabled
    public static  Case getCaseById(String caseId){
       
         System.debug('###'+caseId);
        return [Select Id,CaseNumber,Subject,Status,Priority,ContactEmail,Origin,Reason,ClosedDate,CreatedDate,Description from Case where Id=:caseId LIMIT 1 ];
       
        
    }
    
     @Auraenabled
    public static  List<Case> updateCaseStatus(List<String> caseIds,String statusSelected){
        System.debug('Checking Case Id values'+caseIds);
       List<Case> updateList = new List<Case>();
         
        for(String caseId : caseIds){
            Case newCase = new Case();
            newCase.Id = caseId;
           newCase.Status = statusSelected;
            
            updateList.add(newCase);
        }
        
        update updateList;
        
       return [Select Id,CaseNumber,Subject,Status,Priority from Case LIMIT 10 ];
       
        
    }
    
     @Auraenabled
    public static  List<Case> getAllCaseById(List<String> caseId){
       
         System.debug('###'+caseId);
        return [Select Id,CaseNumber,Subject,Status,Priority from Case where Id=:caseId] ;
       
        
    }
    
    @AuraEnabled
    public static void createRecord (Case Caserec){
        System.debug('@@@'+Caserec);
            if(Caserec != null){
                Caserec.Origin='Phone';
                insert Caserec;
            }
    }  
     @AuraEnabled
 public static List < String > deleteRecords(List < String > lstRecordId) {
  // for store Error Messages  
  List < String > oErrorMsg = new List < String > ();
  // Query Records for delete where id in lstRecordId [which is pass from client side controller] 
  List < Case > lstDeleteRec = [select Id from Case where id IN: lstRecordId];
  
  // delte contact list with Database.DeleteResult[] database class.
  // It deletes some queried contacts using <samp class="codeph apex_code">Database.<span class="statement">delete</span></samp> 
  // with a false second parameter to allow partial processing of records on failure.
  // Next, it iterates through the results to determine whether the operation was successful or not
  // for each record. and check if delete contact successful so print msg on debug, 
  // else add error message to oErrorMsg List and return the list  
  Database.DeleteResult[] DR_Dels = Database.delete(lstDeleteRec, false);
  // Iterate through each returned result
  for (Database.DeleteResult dr: DR_Dels) {
   if (dr.isSuccess()) {
      system.debug('successful delete contact');
     // Operation was successful
   } else {
    // Operation failed, so get all errors   
    oErrorMsg.add('');
    for (Database.Error err: dr.getErrors()) {
     // add Error message to oErrorMsg list and return the list
     oErrorMsg.add(err.getStatusCode() + ': ' + err.getMessage());
    }
   }
  }
  return oErrorMsg;
 
 }
    
    
}