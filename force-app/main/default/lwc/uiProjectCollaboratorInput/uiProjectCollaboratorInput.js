import { LightningElement, api, track } from 'lwc';
import Database from 'c/classDatabase';
import ErrorManager from 'c/classErrorManager';
import EventManager from 'c/classEventManager';


// CONTACT SCHEMA IMPORTS
import CONTACT_OBJ from '@salesforce/schema/Contact';
import CONTACT_ID_FIELD from '@salesforce/schema/Contact.Id';
import CONTACT_NAME_FIELD from '@salesforce/schema/Contact.Name';

// PROJECT COLLABORATOR SCHEMA IMPORTS
import PROJECT_COLLABORATOR_OBJ from '@salesforce/schema/ProjectCollaborator__c';
import PROJECT_COLLABORATOR_ID_FIELD from '@salesforce/schema/ProjectCollaborator__c.Id';
import PROJECT_COLLABORATOR_NAME_FIELD from '@salesforce/schema/ProjectCollaborator__c.Name';
import PROJECT_COLLABORATOR_PROJECT_FIELD from '@salesforce/schema/ProjectCollaborator__c.Project__c';
import PROJECT_COLLABORATOR_CONTACT_FIELD from '@salesforce/schema/ProjectCollaborator__c.Contact__c';
import PROJECT_COLLABORATOR_CONTACT_ID_FIELD from '@salesforce/schema/ProjectCollaborator__c.Contact__r.Id';
import PROJECT_COLLABORATOR_CONTACT_NAME_FIELD from '@salesforce/schema/ProjectCollaborator__c.Contact__r.Name';
import PROJECT_COLLABORATOR_CONTACT_USER_FIELD from '@salesforce/schema/ProjectCollaborator__c.Contact__r.User__c';

const CONTACT_FIELDS = {
    Id: CONTACT_ID_FIELD.fieldApiName,
    Name: CONTACT_NAME_FIELD.fieldApiName,
};

const PROJECT_COLLABORATOR_FIELDS = {
    Id: PROJECT_COLLABORATOR_ID_FIELD.fieldApiName,
    Name: PROJECT_COLLABORATOR_NAME_FIELD.fieldApiName,
    Contact: PROJECT_COLLABORATOR_CONTACT_FIELD.fieldApiName,
    ContactId: PROJECT_COLLABORATOR_CONTACT_ID_FIELD.fieldApiName,
    ContactName: PROJECT_COLLABORATOR_CONTACT_NAME_FIELD.fieldApiName,
    Project: PROJECT_COLLABORATOR_PROJECT_FIELD.fieldApiName,
    ContactUser: PROJECT_COLLABORATOR_CONTACT_USER_FIELD.fieldApiName,
};

export default class ProjectCollaboratorInput extends LightningElement {

    @api name = 'ProjectCollaboratorInput';
    @api label;
    @api messageWhenValueMissing;
    @api fields = Object.values(CONTACT_FIELDS);
    @api objectApiName = CONTACT_OBJ.objectApiName;
    @api iconName = 'standard:contact';
    @api readOnly = false;

    @api 
    get where(){
        return this._where;
    }
    set where(value){
        this.setAttribute('where', value);
        this._where = value;
    }
    @api 
    get recordId(){
        return this._recordId;
    }
    set recordId(value){
        this.setAttribute('recordId', value);
        this._recordId = value;
    }
    @api 
    get required(){
        return this._required;
    }
    set required(value){
        this.setAttribute('required', value);
        this._required = value;
    }
    @api 
    get projectId(){
        return this._projectId;
    }
    set projectId(value){
        this.setAttribute('projectId', value);
        this._projectId = value;
        this.queryProjectCollaborators().then(() => {

        });
    }

    @track _where = {};
    @track _recordId;
    @track _required = false;
    @track _projectId;

    connectedCallback(){
        console.log(this.name + ' connectedCallback()');
        this.queryProjectCollaborators().then(() => {

        });
    }

    handleSelect(event){
        console.log(this.name + ' handleSelect()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const eventBuilder = EventManager.eventBuilder('select');
        eventBuilder.addValue('value', detail.value);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
    }

    handleRemove(event){
        console.log(this.name + ' handleRemove()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        this._recordId = undefined;
        const eventBuilder = EventManager.eventBuilder('remove');
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
    }

    async queryProjectCollaborators() {
        console.log(this.name + ' queryProjectCollaborators()');
        console.log(this.projectId);
        const pcQuery = Database.queryBuilder(PROJECT_COLLABORATOR_OBJ.objectApiName, Object.values(PROJECT_COLLABORATOR_FIELDS));
        pcQuery.addWhereCondition(PROJECT_COLLABORATOR_PROJECT_FIELD.fieldApiName, '=', this.projectId);
        try {
            const result = await Database.query(pcQuery);
            const contactIds = [];
            for (const record of result) {
                contactIds.push(record[PROJECT_COLLABORATOR_CONTACT_FIELD.fieldApiName]);
            }
            if (contactIds.length > 0) {
                this.where = [{
                    field: CONTACT_ID_FIELD.fieldApiName,
                    operator: 'in',
                    value: contactIds
                }];
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }

}