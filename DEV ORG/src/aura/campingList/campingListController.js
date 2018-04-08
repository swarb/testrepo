({
	doInit  : function(component, event, helper) {
		var action = component.get("c.getItems");
        action.setCallback(this, function(response){
            var state = response.getState();
           
            if (component.isValid() && state === "SUCCESS") {
           
               
                component.set("v.items", response.getReturnValue());
                 
            }
        });
        
        $A.enqueueAction(action);
	},
    CreateCamping : function(component, event, helper){
        
        helper.validateFields (component,component.find("name"));
        helper.validateFields (component,component.find("Price"));
        helper.validateFields (component,component.find("Quantity"));
        if(component.get("v.er") === false)
        {
            var lstItems = component.get("v.items");
            var Item = component.get("v.newItem");
            console.log('Before:'+lstItems);
            lstItems.push(Item);
            helper.CreateItem(component,Item);
            component.set("v.items",lstItems);  
             console.log('After:'+lstItems);
            component.set("v.newItem",{ 'sobjectType': 'Camping_Item__c',
                'Name': '',
                'Quantity__c': 0,
                'Price__c': 0,
                'Packed__c': false });
           
        }
	},
    clickCreateItem : function(component, event, helper) {

        //  check for validation
        var checkField = component.find("itemform").reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);



        if (checkField)
        {
            //  gets refernce to view's newItem attribute
            var newItemRef = component.get("v.newItem");
            console.log("Create Camping Item: " + JSON.stringify(newItemRef));
            
            
            // **** begin helper class code ****
            // note that i originally created helper class to perform the logic below
            // but it appears as though the challenge is expecting you NOT to use helper class
            // which would be why i was getting challenge error while using it
            var theItems = component.get("v.items");
 
            // Copy the expense to a new object
            // THIS IS A DISGUSTING, TEMPORARY HACK
            var newItem = JSON.parse(JSON.stringify(newItemRef));    
            theItems.push(newItem);
            component.set("v.items", theItems);
            
            component.set("v.newItem", 
                          {'sobjectType' : 'Camping_Item__c',
                           'Name' : '',
                           'Quantity__c' : 0,
                           'Price__c' : 0,
                           'Packed__c' : false});
                           
        }
        
	},
    handleAddItem: function(component, event, helper) {
        var item = event.getParam("item");
                
        var action = component.get("c.saveItem");
        action.setParams({
            "item": item
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {        
                var theItems = component.get("v.items");
                theItems.push(item);
                component.set("v.items",theItems);
            }
        });
        $A.enqueueAction(action);
    }
})