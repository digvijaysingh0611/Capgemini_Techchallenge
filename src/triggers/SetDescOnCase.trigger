trigger SetDescOnCase on LiveChatTranscript (after insert) 
{    
    LiveChatTranscript[] scripts = Trigger.new;     
    if(scripts == null)         
        return;     
    if(scripts.size() <= 0)   
        return;    
    LiveChatTranscript script = scripts[0]; 
    System.debug('@@script'+script);    
    String body = script.Body;  
    String caseid = script.CaseId;   
    String email = '';    
    List<Case> cases = new List<Case>();	  
    
    Case c = new Case();
    c.Subject = 'chat with Live Agent';
    c.Type = 'Work';
    c.Description = script.Body.stripHtmlTags();    
    cases.add(c);      
    insert cases;  
    
}