/**
* name: SubmitDetailsQuickActionController
* author: Mihir Singh
* createDate: 24-03-2021
* for-desktop: yes
* for-mobile: yes
* description: controller for Submit Details Quick Action Button
*/
({
    
    doInit : function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log(recordId);
        var action = component.get('c.sendSubmitDetailsEmail');
        action.setParams({LeadId: recordId});
        action.setCallback(this, (response) => {
            // if(response.getState() == "SUCCESS") {
            //     var toastEvent = $A.get("e.force:showToast");
            //     toastEvent.setParams({
            //         title: "Lead has been emailed!",
            //         type: "success"
            //     });
            //     toastEvent.fire();
            // } else {
            //     var toastEvent = $A.get("e.force:showToast");
            //     toastEvent.setParams({
            //         title: "Something went wrong.",
            //         type: "error"
            //     });
            //     toastEvent.fire();
            // }
        });
        $A.enqueueAction(action);
    },
    
    doneRendering: function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})