import { LightningElement, track } from 'lwc';
import submitNewLead from '@salesforce/apex/LeadSubmitHandler.submitNewLead';

export default class RegisterPage extends LightningElement {

    @track leadDetails = {};

    get titleOptions() {
        return [
            { label: 'Mr.', value: 'Mr.' },
            { label: 'Mrs.', value: 'Mrs.' },
            { label: 'Ms.', value: 'Ms.' },
            { label: 'Dr.', value: 'Dr.' },
        ];
    }

    get industry_options() {
        return [
            { label: 'Agriculture', value: 'Agriculture' },
            { label: 'Finance', value: 'Finance' },
            { label: 'Construction', value: 'Construction' },
            { label: 'Education', value: 'Education' },
            { label: 'Engineering', value: 'Engineering' },
            { label: 'Medical', value: 'Medical' },
        ];
    }

    get type_firm_options() {
        return [
            { label: 'Proprietary', value: 'Proprietary' },
            { label: 'Finance', value: 'Finance' },
            { label: 'Law', value: 'Law' },
            { label: 'Sole Partner', value: 'Sole Partner' },
            { label: 'Partner', value: 'Partner' },
        ];
    }

    handleFormInputChange(event) {
        this.leadDetails[event.target.name] = event.target.value;
    }

    submitDetails() {
        console.log(JSON.parse(JSON.stringify(this.leadDetails)));
        var objToSend = ({
            incoming: JSON.stringify(this.leadDetails)
        })
        
        submitNewLead({ incoming: objToSend })
        .then((res) => {
            console.log(res);
            alert('Your details have been submitted successfully!');
        })
        .catch((err) => {
            console.log(err);
            alert('Oops something went wrong!');
        });
    }

}