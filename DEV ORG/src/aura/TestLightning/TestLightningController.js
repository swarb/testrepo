({
	handleClick : function(component, event, helper) {
		var total = component.get("v.test1")+component.get("v.test2");
        component.set("v.test3", total);
	}
})