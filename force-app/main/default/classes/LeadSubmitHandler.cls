/**
* name: LeadSubmitHandler
* author: Mihir Singh
* create-date: 2021-04-02
* description: handler for submitting leads from public sign-up
*/
public without sharing class LeadSubmitHandler {

    class LeadToSubmit {
        String title;
        String first_name;
        String last_name;
        String company;
        String designation;
        String phone;
        String email;
        String industry_segment;
        String street_address;
        String city;
        String postal_code;
        String country;
        String state;
        String type_of_firm;
        String bday;
        String comments;
    }

    @AuraEnabled
    public static Lead submitNewLead(Map<String, String> incoming) {
        System.debug('incm :: ' + incoming);
        String incomingMap = incoming.get('incoming');
        LeadToSubmit leadToSubmit = (LeadToSubmit) JSON.deserialize(incomingMap, LeadToSubmit.class);
        
        System.debug('recv :: ' + leadToSubmit);        
        return createNewLead(leadToSubmit);
    }
    
    private static Lead createNewLead(LeadToSubmit leadToSubmit) {
        Lead newLead = new Lead();
        newLead.FirstName = leadToSubmit.first_name;
        newLead.LastName = leadToSubmit.last_name;
        newLead.Company = leadToSubmit.company;
        if(leadToSubmit.title != null) newLead.Title = leadToSubmit.title;
        if(leadToSubmit.designation != null) newLead.Designation__c = leadToSubmit.designation;
        if(leadToSubmit.phone != null) newLead.Phone = leadToSubmit.phone;
        if(leadToSubmit.email != null) newLead.Email = leadToSubmit.email;
        if(leadToSubmit.industry_segment != null) newLead.Industry = leadToSubmit.industry_segment;
        if(leadToSubmit.street_address != null) newLead.Street = leadToSubmit.street_address;
        if(leadToSubmit.city != null) newLead.City = leadToSubmit.city;
        if(leadToSubmit.postal_code != null) newLead.PostalCode = leadToSubmit.postal_code;
        if(leadToSubmit.country != null) newLead.Country = leadToSubmit.country;
        if(leadToSubmit.state != null) newLead.State = leadToSubmit.state;
        if(leadToSubmit.type_of_firm != null) newLead.Type_of_Firm__c = leadToSubmit.type_of_firm;
        System.debug(leadToSubmit.bday);
        if(leadToSubmit.bday != null) newLead.Birthday__c = Date.valueOf(leadToSubmit.bday);
        if(leadToSubmit.comments != null) newLead.Description = leadToSubmit.comments;

        insert newLead;
        sendSubmitDetailsEmail(newLead);

        return newLead;
    }

    @AuraEnabled
    public static Lead sendSubmitDetailsEmail(Lead thisLead) {
        System.debug('Sending Email to :: ' + thisLead);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> emailTo = new List<String>{thisLead.Email};
        email.setToAddresses(emailTo);
        email.setSubject('Application Received!');
        email.setHtmlBody('Hi '+ thisLead.LastName +', Thank you for Applying. Your application was receieved.' );
        
        System.debug('Outgoing Email :: ' + email);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

        return thisLead;
    }

}
