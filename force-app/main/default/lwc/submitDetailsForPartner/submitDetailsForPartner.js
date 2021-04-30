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
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import SubmitDetailsToLead from '@salesforce/apex/SubmitDetails.submitDetailsToLead';

export default class SubmitDetailsForPartner extends LightningElement {
    
    @wire(CurrentPageReference)currentPageReference;
    @track adhar_card_label;
    @track pan_card_label;
    @track passport_label;
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
        var cmpName = event.target.name;
        var cmpVal = event.target.value;
        this.partnerDetails[cmpName] = cmpVal;
        if (event.target.files) {
            let reader = new FileReader();
            reader.readAsDataURL(event.target.files[0]);
            console.log(reader.result);
            reader.onload = () => {
                this.partnerDetails[cmpName] = {
                    name: cmpVal.split('.').slice(-1)[0],
                    data: encodeURIComponent(reader.result.split('base64,')[1]),
                    type: (reader.result.split('base64,')[0]).split(':')[1]
                }
                switch (cmpName) {
                    case 'aadhar_card': this.adhar_card_label = cmpVal; break;
                    case 'pan_card': this.pan_card_label = cmpVal; break;
                    case 'passport': this.passport_label = cmpVal; break;
                    default: break;
                }
            }
            reader.onerror = () => {
                console.log(reader.error);
            }
        }
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
            alert('Your details have been submitted Successfully!');
            // this.dispatchEvent (
            //     new ShowToastEvent ({
            //         title: 'Data Submitted!',
            //         message: 'Your submitted data will be updated.',
            //         variant: 'success'
            //     })
            // );
        })
        .catch((err) => {
            console.log(err);
            alert('Oops! Something went Wrong!');
            // this.dispatchEvent (
            //     new ShowToastEvent ({
            //         title: 'Oops!',
            //         message: 'Something went wrong.',
            //         variant: 'success'
            //     })
            // );
        })
    }
}