({
    //get Account List from apex controller
    doInit : function(component, event, helper) {
        var action = component.get("c.getAccList");
        action.setParams({
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.AccountList",result.getReturnValue());   
            }
        });
        $A.enqueueAction(action);
        helper.fetchPickListVal(component, 'Industry', 'accIndustry');
    },
    onPicklistChange : function(component, event, helper) {
        //alert(event.getSource().get("v.value"));
        component.set("v.SelectedCaseStatus",event.getSource().get("v.value"));
    },
    onStatusUpdate: function(component, event, helper) {
        //SelectedCaseStatus
        // get the value of select option
        // console.log('@@'+component.get("v.SelectedCaseStatus"));
        // console.log('%%'+component.get('v.EditCasesList'));
        /* var delId = [];
                            // get all checkboxes 
                            var getAllId = component.find("checkAccount");
                            // If the local ID is unique[in single record case], find() returns the component. not array
                            if(! Array.isArray(getAllId)){
                                if (getAllId.get("v.value") == true) {
                                    delId.push(getAllId.get("v.text"));
                                }
                            }else{
                                // play a for loop and check every checkbox values 
                                // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
                                for (var i = 0; i < getAllId.length; i++) {
                                    if (getAllId[i].get("v.value") == true) {
                                       delId.push(getAllId[i].get("v.text"));
                                    }
                                }
                            } 
      	 console.log('@@StatusdelId'+delId);
         console.log(component.get("v.SelectedCaseStatus"));*/
        var listId= component.get("v.updateIdList");
        var action= component.get("c.updateCaseStatus");
        action.setParams({caseIds: listId,statusSelected : component.get("v.SelectedCaseStatus")});
        action.setCallback(this, function(response) {
            console.log('Callback after update'+response.getReturnValue());
            component.set("v.AccountList",response.getReturnValue());
            component.set("v.isUpdateForm", false);
        });
        $A.enqueueAction(action);
    },
    
    
    //Select all Accounts
    handleSelectAllAccount: function(component, event, helper) {
        var getID = component.get("v.AccountList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkAccount = component.find("checkAccount"); 
        console.log('@@checkAccount'+checkAccount);
        if(checkvalue == true){
            for(var i=0; i<checkAccount.length; i++){
                checkAccount[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkAccount.length; i++){
                checkAccount[i].set("v.value",false);
            }
        }
    },
    delete : function(component, event, helper) {        
    if(confirm('Are you sure?'))
    helper.deleteAccount(component, event);        
},
 EditModal: function(component, event, helper) {
    // for Display Model,set the "isOpen" attribute to "true"
    component.set("v.isOpen", true);
    component.set("v.editId", event.target.id);
    var action= component.get("c.EditCaseById");
    action.setParams({editid: event.target.id});
    action.setCallback(this, function(response) {
        component.set("v.EditList",response.getReturnValue());
    });
    $A.enqueueAction(action);
},
    ShowDetails: function(component, event, helper) {
        
        component.set("v.editId", event.target.id);
        var action= component.get("c.getCaseById");
        action.setParams({caseId: component.get("v.editId")});
        action.setCallback(this, function(response) {
            //console.log('Checking val show '+ JSON.stringify(response.getReturnValue()));
            component.set("v.showCase",response.getReturnValue());
            
            component.set("v.LowerCaseform",true);
            
        });
        $A.enqueueAction(action);
    },
        NewModal:function(component, event, helper) {
            component.set("v.isCaseForm", true);
        },
            UpdateModal:function(component, event, helper) {
                component.set("v.isUpdateForm", true);
                var delId = [];
                // get all checkboxes 
                var getAllId = component.find("checkAccount");
                // If the local ID is unique[in single record case], find() returns the component. not array
                if(! Array.isArray(getAllId)){
                    if (getAllId.get("v.value") == true) {
                        delId.push(getAllId.get("v.text"));
                    }
                }else{
                    // play a for loop and check every checkbox values 
                    // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
                    for (var i = 0; i < getAllId.length; i++) {
                        if (getAllId[i].get("v.value") == true) {
                            delId.push(getAllId[i].get("v.text"));
                        }
                    }
                } 
                
                var action= component.get("c.getAllCaseById");
                action.setParams({caseId: delId});
                action.setCallback(this, function(response) {
                    console.log('Checking val show '+ JSON.stringify(response.getReturnValue()));
                    component.set("v.EditCasesList",response.getReturnValue());
                    var listId= response.getReturnValue();
                    var idList=[];
                    for(var item in listId)
                    { 
                        for(var inneritem in listId[item])
                        {
                            if(inneritem == 'Id')
                            {
                                
                                idList.push(listId[item][inneritem]);
                            }
                        }
                    }
                    component.set("v.updateIdList",idList);
                    
                    
                });
                $A.enqueueAction(action);
                
            },
                
                closeModel: function(component, event, helper) {
                    // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
                    component.set("v.isOpen", false);
                    component.set("v.isCaseForm", false);
                    component.set("v.isUpdateForm", false);
                    component.set("v.LowerCaseform", false);
                    // component.set("v.isToastForm", false);
                },
                    Create : function(component, event, helper) {
                        console.log('Create record');
                        
                        var Case = component.get("v.Case");
                        //Validation
                        if($A.util.isEmpty(Case.Subject) || $A.util.isUndefined(Case.Subject)){
                            alert('Subject is Required');
                            return;
                        }            
                        if($A.util.isEmpty(Case.Status) || $A.util.isUndefined(Case.Status)){
                            alert('Status is Required');
                            return;
                        }
                        if($A.util.isEmpty(Case.Priority) || $A.util.isUndefined(Case.Priority)){
                            alert('Priority is Required');
                            return;
                        }
                        
                        var action = component.get('c.createRecord');        
                        
                        action.setParams({
                            Caserec : Case
                        });
                        
                        //helper.showToast(component, event);
                        action.setCallback(this,function(a){
                            //get the response state
                            var state = a.getState();
                            
                            //check if result is successfull
                            if(state == "SUCCESS"){
                                console.log("Case inserted");
                                component.set("v.isCaseForm", false);
                                //helper.showToast(component, event);
                                component.set("v.isToastForm", true);
                                var cmpTarget = component.find('changeIt');
                                $A.util.addClass(cmpTarget, 'changeMe');
                                component.set("v.toastMsg","Case Successfully Created");
                                
                            } else if(state == "ERROR"){
                                alert('Error in calling server side action');
                            }
                        });
                        
                        
                        //adds the server-side action to the queue        
                        $A.enqueueAction(action);
                        
                    },  
                        
                        
                        
                        //Process the selected Account
                        /* handleSelectedContacts: function(component, event, helper) {
        var selectedContacts = [];
        var checkvalue = component.find("checkAccount");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        console.log('selectedContacts-' + selectedContacts);
    }*/
                        
                        Save: function(component, event, helper) {
                            // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
                            var subject= component.find("subject").get("v.value");
                            var status= component.find("status").get("v.value");
                            var priority= component.find("priority").get("v.value");
                            var editId= component.get("v.editId");
                            var reason= component.find("Reason").get("v.value");
                            
                            
                            console.log("Checking values"+subject+status+priority+editId);
                            var action= component.get("c.SaveCaseById");
                            
                            action.setParams({subject:subject,status:status,priority:priority,editid:editId,reason:reason});
                            action.setCallback(this, function(response) {
                                //component.set("v.EditList",response.getReturnValue());
                                component.set("v.AccountList",response.getReturnValue());
                                
                                component.set("v.isOpen", false);
                            });
                            $A.enqueueAction(action);
                        },
                            deleteSelected: function(component, event, helper) {
                                // create var for store record id's for selected checkboxes  
                                var delId = [];
                                // get all checkboxes 
                                var getAllId = component.find("checkAccount");
                                // If the local ID is unique[in single record case], find() returns the component. not array
                                if(! Array.isArray(getAllId)){
                                    if (getAllId.get("v.value") == true) {
                                        delId.push(getAllId.get("v.text"));
                                    }
                                }else{
                                    // play a for loop and check every checkbox values 
                                    // if value is checked(true) then add those Id (store in Text attribute on checkbox) in delId var.
                                    for (var i = 0; i < getAllId.length; i++) {
                                        if (getAllId[i].get("v.value") == true) {
                                            delId.push(getAllId[i].get("v.text"));
                                        }
                                    }
                                } 
                                
                                // call the helper function and pass all selected record id's. 
                                if(confirm('Are you sure?'))   
                                    helper.deleteSelectedHelper(component, event, delId,function(){
                                        var action = component.get("c.getAccList");
                                        action.setParams({
                                        });
                                        action.setCallback(this, function(result){
                                            var state = result.getState();
                                            if (component.isValid() && state === "SUCCESS"){
                                                component.set("v.AccountList",result.getReturnValue());   
                                            }
                                        });
                                        $A.enqueueAction(action);
                                    });
                                
                            },
                                
})