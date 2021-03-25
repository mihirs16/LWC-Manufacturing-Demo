/**
* name: SubmitDetails
* author: Mihir Singh
* createDate: 24-03-2021
* description: class to handle submit details action and input of details from partner
*/
public without sharing class SubmitDetails {

    public Lead thisLead;

    public class PartnerDetails {
        public String leadId;
        public String company_name;
        public String street_address;
        public String country;
        public String state;
        public String city;
        public String postal_code;
        public String phone;
        public String fax;
        public String public_company;
        public String dnb;
        public String ap_email_address;
        // public String federal_id;
        // public String credit_line_req;
        public String freight_carrier;
        public String tax_exempt;
        public String tax_acc_num;
        public String addr_company_name;
        public String addr_street_address;
        public String addr_country;
        public String addr_state;
        public String addr_city;
        public String addr_postal_code;
        public List<CreditReference> creditRefs;
        public FileAttachment aadhar_card;
        public FileAttachment pan_card;
        public FileAttachment passport;
    }

    public class CreditReference {
        String name;
        String email;
        String phone;
    }

    public class FileAttachment {
        String name;
        String data;
        String type;
    }

    @AuraEnabled
    public static void submitDetailsToLead(Map<String, String> incoming) {
        System.debug('map :: ' + incoming);
        String incomingMap = incoming.get('incoming');
        PartnerDetails partnerDetails = (PartnerDetails) JSON.deserialize(incomingMap, PartnerDetails.class);
        System.debug('obj :: ' + partnerDetails);

        if(partnerDetails.leadId != null) {
            updateThisLead(partnerDetails);
            fileUploadAsAttachment(partnerDetails);
        }

    }

    private static void updateThisLead(PartnerDetails partnerDetails) {
        Lead updatedLead = getThisLead(partnerDetails.LeadId);
        
        updatedLead.Id = partnerDetails.leadId;
        updatedLead.Company = partnerDetails.company_name;
        updatedLead.Street  = partnerDetails.street_address;
        updatedLead.City = partnerDetails.city;
        updatedLead.State = partnerDetails.state;
        updatedLead.PostalCode = partnerDetails.postal_code;
        updatedLead.Country = partnerDetails.country;
        updatedLead.Phone = partnerDetails.phone;
        updatedLead.Fax = partnerDetails.fax;
        updatedLead.Public_Company__c = partnerDetails.public_company == 'true' ? true : false;
        updatedLead.D_B_Number__c = partnerDetails.dnb;
        updatedLead.A_P_Email_ID__c = partnerDetails.ap_email_address;
        updatedLead.Freight_Carrier__c = partnerDetails.freight_carrier;
        updatedLead.Tax_Exempt__c = partnerDetails.tax_exempt == 'true' ? true : false;
        updatedLead.Credit_Reference_Name__c = partnerDetails.creditRefs[0].name;
        updatedLead.Credit_Reference_Email__c = partnerDetails.creditRefs[0].email;

        System.debug(updatedLead);
        update updatedLead;
    }

    private static Lead getThisLead(String recordId) {
        return [SELECT Id, Company, Street, City, State, PostalCode, Country, Phone, Fax, Public_Company__c, D_B_Number__c,
                A_P_Email_ID__c, Freight_Carrier__c, Tax_Exempt__c, Credit_Reference_Name__c, Credit_Reference_Email__c
                FROM Lead WHERE Id = :recordId
        ][0];
    }

    private static void fileUploadAsAttachment(PartnerDetails partnerDetails){
        if (partnerDetails.aadhar_card != null) {
            Attachment attachment = new Attachment(
                Body = EncodingUtil.base64Decode(EncodingUtil.urlDecode(partnerDetails.aadhar_card.data, 'UTF-8')),
                Name = 'Aadhar Card.' + partnerDetails.aadhar_card.name,
                ParentId = partnerDetails.leadId
            );
            insert attachment;
        }

        if (partnerDetails.pan_card != null) {
            Attachment attachment = new Attachment(
                Body = EncodingUtil.base64Decode(EncodingUtil.urlDecode(partnerDetails.pan_card.data, 'UTF-8')),
                Name = 'Pan Card.' + partnerDetails.pan_card.name,
                ParentId = partnerDetails.leadId
            );
            insert attachment;
        }

        if (partnerDetails.passport != null) {
            Attachment attachment = new Attachment(
                Body = EncodingUtil.base64Decode(EncodingUtil.urlDecode(partnerDetails.passport.data, 'UTF-8')),
                Name = 'Passport.' + partnerDetails.passport.name,
                ParentId = partnerDetails.leadId
            );
            insert attachment;
        }

    }

    @AuraEnabled
    public static Lead sendSubmitDetailsEmail(String LeadId) {
        Lead thisLead = new Lead();
        thisLead = [SELECT Id, Name, Email FROM Lead WHERE Id = :LeadId][0];

        System.debug('Sending Email to :: ' + thisLead);

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> emailTo = new List<String>{thisLead.Email};
        email.setToAddresses(emailTo);
        email.setSubject('Update Information');
        email.setHtmlBody('Hi '+ thisLead.Name +', <br/><br/>Thank you for showing interest to be a Partner. Please click on the below link and fill in the required details and upload the following documents:<br/><br/>'+
            '1. Aadhaar Card<br/>'+
            '2. Pan Card<br/>'+
            '3. Passport<br/><br/>LINK URL: https://mishacommunity-developer-edition.ap24.force.com/partner/?Id='+thisLead.Id+'<br/><br/>Once we receive and verify your documents, we will get back to you with the next steps.<br/><br/>Regards,<br/> Hublio Team'
        );
        
        System.debug('Outgoing Email :: ' + email);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });

        return thisLead;
    }

}
