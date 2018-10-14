public with sharing class HandlerChatBot {
    @AuraEnabled
    public static string postChatText(string messages){
        String reply;
        
        IBMConversationV1 conversation = new IBMConversationV1('2017-05-26');
        
        IBMConversationV1Models.Context context = null;
        //for (String message : messages) {
        IBMConversationV1Models.InputData input = new IBMConversationV1Models.InputDataBuilder()
            .text(messages)
            .build();
        IBMConversationV1Models.MessageOptions options = new IBMConversationV1Models.MessageOptionsBuilder()
            .workspaceId('346791ae-4913-4f05-b26b-504026498ef1') // Place your workspace ID here!
            .input(input)
            .context(context)
            .build();
        if(!Test.isRunningTest()){
        IBMConversationV1Models.MessageResponse response = conversation.message(options);
        
        reply = response.getOutput().getText().get(0);
        System.debug(String.format('MESSAGE: {0}', new String[]{ messages }));
        System.debug(String.format('{0}\n', new String[]{ reply }));
        
        context = response.getContext();
            }
        return String.format('{0}', new String[]{ reply });
        
    }
    
    @AuraEnabled
    public static void createRecord (Lead lead){
        
        try{
            System.debug('Lead record'+lead);
            
            if(lead != null){
                lead.Status='Open - Not Contacted';
                insert lead;
            }
            
        } catch (Exception ex){
            
        }
        
    }  
    
   @AuraEnabled
    public static List<LiveChatTranscript> saveChat (List<string> transcript)
    {   
    
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;
       
        List<LiveChatTranscript> trans = new List<LiveChatTranscript>();
        for(Integer i = 0; i < transcript.size(); i++){
            system.debug('##trans'+transcript.size());
            LiveChatTranscript ts = new LiveChatTranscript();
            ts.Body = string.valueOf(i);
            ts.LiveChatVisitorId= lcv.id;
            System.debug('$$ts'+ts.Body);
            trans.add(ts); 
        }
        System.debug('@@trans'+trans);
        insert trans;
        return trans;
    } 
}