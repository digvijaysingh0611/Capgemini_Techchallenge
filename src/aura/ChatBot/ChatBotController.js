({
    scriptsLoaded: function(component, event, helper){
        console.log("Script loaded");
        (function() {
            
            $('.live-chat header').on('click', function() {
                
                $('.chat').slideToggle(150, 'swing');
                
                $('.chat-message-counter').fadeToggle(200, 'swing');
                
            });
            
            $('.chat-close').on('click', function(e) {
                
                e.preventDefault();
                $('.live-chat').fadeOut(300);
                
            });
            
           
        }) ();
        },
    
    doInit : function(component, event, helper) {
        var today = new Date();
        component.set('v.currentDate', today);
         var url = $A.get('$Resource.liveagent');
        component.set('v.backgroundImageURL', url);
    },
    
    handleClick: function(component, event, helper){
        component.set("v.showButton",false);
        component.set("v.showLiveAgent",true);
        component.set("v.ifmsrc", 'https://digvijay06-dev-ed--c.ap5.visual.force.com/apex/LiveAgentChatBot?core.apexpages.request.devconsole=1');  
        component.set("v.showLoading",false);
   
        
    },
    postUserChat: function(component, event, helper){
        
        if(event.getParams().keyCode !== 13){
            return;
        }
        var chatList = component.get("v.chatInboundList");
        var action = component.get("c.postChatText");
        chatList.push({"User": component.get("v.userChat")});
        console.log('@@User'+component.get("v.userChat"));
        action.setParams({"messages": component.get("v.userChat")});
        component.set("v.userChat", "");
        action.setCallback(this, function(response){
            console.log("Checking values"+response.getReturnValue());
            chatList.push({"Assistant": response.getReturnValue()});
            component.set("v.chatInboundList", chatList);
            console.log('@@chatlist'+JSON.stringify(chatList));
            //var ChatLstobj = JSON.stringify(chatList);
            // console.log('@@chatInboundList'+component.get("v.chatInboundList");
            helper.autoscroll(component, event, helper);
            
            var data = response.getReturnValue();
            if(data=='Would you like me to transfer you to a representative?'){
                component.set("v.showLoading",true);
                console.log("I am able to see"+  component.set("v.showLoading",true));
                component.set("v.showLiveAgent", false);
                component.set("v.showButton", true);
                component.set("v.showChat", false);
               // helper.helperMethod(component, event, helper); 
               
              var chatRec = component.get("v.chatInboundList");
               console.log('@@chatRec'+(JSON.stringify(chatRec)));
                var chatstr = JSON.stringify(chatRec);
                var action1 = component.get('c.saveChat');
                action1.setParams({
                    transcript : chatstr
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
            }
            
           
            
            var navigateUrl = "";
            /*if(!data.result.actionIncomplete && data.result.action === 'OPEN_SCREEN'){
                switch(data.result.parameters.SFObjectEntities){
                    case 'Opportunity':
                        navigateUrl = "/006/o";
                        break;
                    case 'Lead':
                        navigateUrl = "/00Q/o";
                        break;
                    case 'Task':
                        navigateUrl = "00T/o";
                        break;
                    default:
                        navigateUrl = "";
                        break;

                }
                navigateUrl && $A.get("e.force:navigateToURL").setParams({
                  "url": navigateUrl,
                  "isredirect": false
                }).fire();
            }*/
        });
        $A.enqueueAction(action);
       
    },
    
    create : function(component, event, helper) {
        console.log('Create record');
        
        //getting the lead information
        var lead = component.get("v.lead");
        
        //Validation
        if($A.util.isEmpty(lead.FirstName) || $A.util.isUndefined(lead.FirstName)){
            alert('First Name is Required');
            return;
        }            
        if($A.util.isEmpty(lead.LastName) || $A.util.isUndefined(lead.LastName)){
            alert('Last Name is Rqquired');
            return;
        }
        if($A.util.isEmpty(lead.Email) || $A.util.isUndefined(lead.Email)){
            alert('Email is Required');
            return;
        }
        if($A.util.isEmpty(lead.Company) || $A.util.isUndefined(lead.Company)){
            alert('Company name is required');
            return;
        }
        //Calling the Apex Function
        var action = component.get('c.createRecord');
        
        //Setting the Apex Parameter
        action.setParams({
            lead : lead
        });
        
        //Setting the Callback
        action.setCallback(this,function(a){
            //get the response state
            var state = a.getState();
            
            //check if result is successfull
            if(state == "SUCCESS"){
                console.log("Lead inserted");
                component.set("v.showLeadform", false);
                component.set("v.showChat", true);
                
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            }
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
        
    },
    
})