import { LightningElement, api, wire, track } from 'lwc';
import getCareerEventsByContactId from '@salesforce/apex/ContactJourneyController.getCareerEventsByContactId';

    export default class ContactCareerJourneyComponent extends LightningElement {
        @api recordId;
        @track isDataAvailable = false;
        connectedCallback() {
            this.retrieveKanletData();
        }
    @track Company;
    @track Job_Title;
    @track Contact_Status;
    @track New_Company;
    @track New_Designation;

    retrieveKanletData() {
        console.log('retrieveKanletData function call');
        console.log('this.recordId ==>', this.recordId);
        getCareerEventsByContactId({ contactId: this.recordId })
            .then(result => {
                console.log('Kanlet data retrieved:', result);
                console.log('Kanlet data retrieved:JSON  ', JSON.stringify(result));
                this.kanletData = result;
                this.Company = result.Company__c;
                this.Job_Title = result.Job_Title__c;
                this.Contact_Status = result.Contact_Status__c;
                this.New_Company = result.New_Company__c;
                this.New_Designation = result.New_Designation__c;
                if (result) {
                    this.isDataAvailable = true;
                }

            })
            .catch(error => {
                console.error('Error fetching Kanlet data:', error);
                console.log('Error fetching Kanlet data without JSON', error);
                console.log('Error fetching Kanlet data with JSON', JSON.stringify(error));
            });
    }
    handleClick(){

    }
}