({
	packItem : function(component, event, helper) {
		var button = event.getSource();
        var a = component.get("v.item");
        a.Packed__c = true;
        component.set("v.item", a);
		button.set("v.disabled", true);
	}
})