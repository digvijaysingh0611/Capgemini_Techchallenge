({
    deleteAccount : function(component, event) {
        console.log('in delete account helper method.');
        var action = component.get("c.delteAccountById");
        action.setParams({accid: event.target.id});
        action.setCallback(this, function(response) {
            component.set("v.AccountList",response.getReturnValue());
        });
        $A.enqueueAction(action);
    }, 
    deleteSelectedHelper: function(component, event, deleteRecordsIds,callback) {
        //call apex class method
       
        var action = component.get('c.deleteRecords');
        // pass the all selected record's Id's to apex method 
        action.setParams({
            "lstRecordId": deleteRecordsIds
        });
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(state);
                if (response.getReturnValue() != '') {
                    // if getting any error while delete the records , then display a alert msg/
                    alert('The following error has occurred. while Delete record-->' + response.getReturnValue());
                } else {
                    console.log('check it--> delete successful');
                }
                // call the onLoad function for refresh the List view    
                callback();
            }
        });
        $A.enqueueAction(action);
    },
     fetchPickListVal: function(component, fieldName, elementId) {
       /* var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
        */
    },
    
    showToast : function(component, event) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
        "title": "Success!",
        "type": "success",
        "message": "New Case is created."
    });
    toastEvent.fire();
    },

    
})