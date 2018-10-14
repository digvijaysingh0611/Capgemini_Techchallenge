({
	helperMethod : function(component, event, helper) {
       
         var chatRec = JSON.stringify(chatList);
                console.log('@@chatRec'+chatRec);
                var action1 = component.get('c.saveChat');
                action1.setParams({
                    transcript : chatRec
                });
                //Setting the Callback
                action1.setCallback(this,function(a){
                    //get the response state
                    var state = a.getState();
                    
                    //check if result is successfull
                    if(state == "SUCCESS"){
                        console.log("chat inserted");
                       
                        
                    } else if(state == "ERROR"){
                        alert('Error in calling server side action');
                    }
                });
                
                //adds the server-side action to the queue        
                $A.enqueueAction(action1);
       
		
	},
    autoscroll:function(component, event, helper){
   
        var height = 0;
        $('div p').each(function(i, value){
            console.log("parseInt"+parseInt($(this).height()));
            height += parseInt($(this).height());
             console.log("heightFirst"+height);
        });
        
        height += '';
        console.log("heightSec"+height);
        
        $('div').animate({scrollTop: height});
        
       
       
        
    }
})