/**
* name: SubmitDetailsForPartner
* author: Mihir Singh
* createDate: 24-03-2021
* for-desktop: yes
* for-mobile: yes
* description: public page component for submitting partner details
*/
import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import SubmitDetailsToLead from '@salesforce/apex/SubmitDetails.submitDetailsToLead';

export default class SubmitDetailsForPartner extends LightningElement {
    
    @wire(CurrentPageReference)currentPageReference;
    @track partnerDetails = {};
    @track creditRefs = [{
        index: 0,
        name: '',
        email: '',
        phone: ''
    }];
    @track files = {};

    get options_tax() {
        return [
            { label: 'Yes', value: true },
            { label: 'No', value: false },
        ];
    }

    get options_freight() {
        return [
            { label: 'UPS', value: 'UPS' },
            { label: 'DHL', value: 'DHL' },
            { label: 'FedEx', value: 'fedex' },
            { label: 'Other', value: 'other' },
        ];
    }

    connectedCallback() {
        this.partnerDetails['leadId'] = this.currentPageReference.state.Id
    }

    handleFormInputChange(event){
        this.partnerDetails[event.target.name] = event.target.value;
        // if(event.target.files) {
        //     this.partnerDetails[event.target.name] = event.target.files;
        //     console.log(event.target.files);
        //     var reader = new FileReader();
        //     reader.onload = () => {
        //         this.partnerDetails[event.target.name.toString() + '_content'] = reader.result;
        //     }
        //     reader.readAsDataURL(this.partnerDetails[event.target.name]);
        // }
        // console.log(event.target.name + ' now is set to ' + event.target.value);
    }

    addCreditRef() {
        this.creditRefs.push({
            index: this.creditRefs.length,
            name: '',
            email: '',
            phone: ''
        })
    }

    handleCredRefInput(event) {
        this.creditRefs[event.target.dataset.id][event.target.name] = event.target.value;
    }

    submitDetails() {
        this.partnerDetails['creditRefs'] = this.creditRefs;
        console.log(JSON.parse(JSON.stringify(this.partnerDetails)));
        var objToSend = ({
            incoming: JSON.stringify(this.partnerDetails)
        })
        SubmitDetailsToLead({ incoming: objToSend })
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        })
    }
}