import { LightningElement, api, track } from 'lwc';
import Database from 'c/classDatabase';
import ToastManager from 'c/classToastManager';
import ErrorManager from 'c/classErrorManager';
import EventManager from 'c/classEventManager';
import QuickActionUtils from 'c/classQuickActionUtils';
import UserInfo from 'c/classUserInfo';
import SchemaUtils from 'c/classSchemaUtils';
import URLUtils from 'c/classURLUtils';
import DOMUtils from 'c/classDOMUtils';
import Validator from 'c/classValidator';
import DateTimeUtils from 'c/classDateTimeUtils';

// LABELS IMPORT
import SAVE_LBL from '@salesforce/label/c.Save';
import CANCE_LBL from '@salesforce/label/c.Cancel';
import ERROR_LBL from '@salesforce/label/c.Error';
import NEW_ISSUE_STATUS_ORDER_LBL from '@salesforce/label/c.NewIssueStatusOrder';
import EDIT_LBL from '@salesforce/label/c.Edit';
import CHANGE_TO_LBL from '@salesforce/label/c.ChangeTo';
import STATUS_LBL from '@salesforce/label/c.Status';
import ASSIGN_TO_LBL from '@salesforce/label/c.AssignTo';
import REQUIRED_CHANGE_TO_STATUS_ERROR_LBL from '@salesforce/label/c.RequiredChangeToStatusError';
import TO_LAST_ASSIGNMENT_LBL from '@salesforce/label/c.ToLastAssignment';

// ISSUE STATUS SCHEMA IMPORTS
import ISSUE_STATUS_OBJ from '@salesforce/schema/IssueStatus__c';
import ISSUE_STATUS_ID_FIELD from '@salesforce/schema/IssueStatus__c.Id';
import ISSUE_STATUS_NAME_FIELD from '@salesforce/schema/IssueStatus__c.Name';
import ISSUE_STATUS_ACTIVE_FIELD from '@salesforce/schema/IssueStatus__c.Active__c';
import ISSUE_STATUS_PROJECT_FIELD from '@salesforce/schema/IssueStatus__c.Project__c';

// ISSUE STATUS ORDER SCHEMA IMPORTS
import ISSUE_STATUS_ORDER_OBJ from '@salesforce/schema/IssueStatusOrder__c';
import ISSUE_STATUS_ORDER_ID_FIELD from '@salesforce/schema/IssueStatusOrder__c.Id';
import ISSUE_STATUS_ORDER_NAME_FIELD from '@salesforce/schema/IssueStatusOrder__c.Name';
import ISSUE_STATUS_ORDER_ASSIGN_TO_FIELD from '@salesforce/schema/IssueStatusOrder__c.AssignTo__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__c';
import ISSUE_STATUS_ORDER_STATUS_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__c';
import ISSUE_STATUS_ORDER_STATUS_PROJECT_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__r.Project__c';
import ISSUE_STATUS_ORDER_LAST_ASSIGNMENT_FIELD from '@salesforce/schema/IssueStatusOrder__c.ToLastAssignment__c';

const LABELS = {
    Save: SAVE_LBL,
    Cancel: CANCE_LBL,
    NewIssueStatusOrder: NEW_ISSUE_STATUS_ORDER_LBL,
    Edit: EDIT_LBL,
    ChangeTo: CHANGE_TO_LBL,
    Status: STATUS_LBL,
    AssignTo: ASSIGN_TO_LBL,
    RequiredChangeToStatusError: REQUIRED_CHANGE_TO_STATUS_ERROR_LBL,
    Error: ERROR_LBL,
    ToLastAssignment: TO_LAST_ASSIGNMENT_LBL,
};

const ISSUE_STATUS_ORDER_FIELDS = {
    Id: ISSUE_STATUS_ORDER_ID_FIELD.fieldApiName,
    Name: ISSUE_STATUS_ORDER_NAME_FIELD.fieldApiName,
    AssignId: ISSUE_STATUS_ORDER_ASSIGN_TO_FIELD.fieldApiName,
    ChangeToId: ISSUE_STATUS_ORDER_CHANGE_TO_FIELD.fieldApiName,
    StatusId: ISSUE_STATUS_ORDER_STATUS_FIELD.fieldApiName,
    StatusProject: ISSUE_STATUS_ORDER_STATUS_PROJECT_FIELD.fieldApiName,
    ToLastAssingment: ISSUE_STATUS_ORDER_LAST_ASSIGNMENT_FIELD.fieldApiName,
};

const ISSUE_STATUS_FIELDS = {
    Id: ISSUE_STATUS_ID_FIELD.fieldApiName,
    Name: ISSUE_STATUS_NAME_FIELD.fieldApiName,
    Active: ISSUE_STATUS_ACTIVE_FIELD.fieldApiName,
    Project: ISSUE_STATUS_PROJECT_FIELD.fieldApiName,
};

const CANCEL_BUTTON = {
    name: "cancel",
    label: LABELS.Cancel,
    title: LABELS.Cancel,
    variant: 'neutral'
};

const SAVE_BUTTON = {
    name: "save",
    label: LABELS.Save,
    title: LABELS.Save,
    variant: 'brand',
};

export default class NewIssueStatusOrder extends LightningElement {
    @api name = 'NewIssueStatusOrder';
    @api objectApiName;
    @api recordId;
    @api statusId;
    @api changeToId;

    @track loading = true;
    @track resizable = true;
    @track title = LABELS.NewIssueStatusOrder;
    @track buttons = [CANCEL_BUTTON, SAVE_BUTTON];
    @track editMode = false;
    @track record = Database.createSObject(ISSUE_STATUS_ORDER_OBJ.objectApiName);
    @track status;
    @track statusLookup = {
        obj: ISSUE_STATUS_OBJ.objectApiName,
        iconName: 'custom:custom63',
        where: [],
        fields: Object.values(ISSUE_STATUS_FIELDS),
    };
    @track changeToLookup = {
        obj: ISSUE_STATUS_OBJ.objectApiName,
        iconName: 'custom:custom63',
        where: [],
        fields: Object.values(ISSUE_STATUS_FIELDS),
    };
    labels = LABELS;
    fields = ISSUE_STATUS_ORDER_FIELDS;

    async connectedCallback() {
        console.log(this.name + ' connectedCallback()');
        this.loading = true;
        this.editMode = this.recordId !== undefined;
        this.getContextData();
        await this.queryIssueStatus();
        //await this.queryProjectCollaborators();
        if (this.editMode) {
            await this.queryIssueStatusOrder();
        } else {
            this.record.fields[ISSUE_STATUS_ORDER_FIELDS.StatusId] = this.statusId;
        }
        this.loading = false;
    }

    async handleClick(event) {
        console.log(this.name + ' handleClick()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        if (source === 'footer') {
            if (detail.button === SAVE_BUTTON.name) {
                try {
                    this.loading = true;
                    if (this.editMode) {
                        this.record = await Database.update(this.record);
                    } else {
                        this.record = await Database.insert(this.record);
                    }
                    this.record = Database.createSObject(ISSUE_STATUS_ORDER_OBJ.objectApiName, this.record);
                    window.history.back();
                } catch (error) {
                    this.loading = false;
                    const err = ErrorManager.getError(error);
                    ToastManager.showErrorToast(this, LABELS.Error, err.message);
                }
            } else if (detail.button === CANCEL_BUTTON.name) {
                window.history.back();
            }
        }
    }

    handleResize(event) {
        console.log(this.name + ' handleResize()');
        const detail = EventManager.getEventDetail(event);
        QuickActionUtils.resize(this, detail.style);
    }

    handleChange(event) {
        console.log(this.name + ' handleChange()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const fields = Object.values(ISSUE_STATUS_ORDER_FIELDS);
        if (fields.includes(source)) {
            if (detail.hasOwnProperty('checked')) {
                this.assignedToLookup.disabled = detail.checked;
                this.record.fields[source] = detail.checked;
            }
        }
        this.validate();
    }

    handleSelect(event) {
        console.log(this.name + ' handleSelect()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const fields = Object.values(ISSUE_STATUS_ORDER_FIELDS);
        if (fields.includes(source)) {
            if (detail.value.Id) {
                this.record.fields[source] = detail.value.Id;
            }
        }
        this.validate();
    }

    handleRemove(event) {
        console.log(this.name + ' handleRemove()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const fields = Object.values(ISSUE_STATUS_ORDER_FIELDS);
        if (fields.includes(source)) {
            this.record.fields[source] = undefined;
        }
        this.validate();
    }

    getContextData() {
        console.log(this.name + ' getContextData()');
        const contextData = URLUtils.getContextOfRefData();
        if (contextData && contextData.attributes) {
            if (contextData.attributes.objectApiName === ISSUE_STATUS_OBJ.objectApiName) {
                this.statusId = contextData.attributes.recordId;
            }
        }
    }

    validate() {
        let valid = true;
        const footer = DOMUtils.queryByDataName(this, 'footer');
        const input = DOMUtils.queryByDataName(this, ISSUE_STATUS_ORDER_FIELDS.ChangeTo);
        if (input) {
            if (!this.record.fields[ISSUE_STATUS_ORDER_FIELDS.ChangeTo]) {
                valid = false;
                input.setCustomValidity(LABELS.RequiredChangeToStatusError);
            } else {
                input.setCustomValidity('');
            }
            input.reportValidity();
        }
        if (footer) {
            if (valid) {
                footer.enableButton(SAVE_BUTTON.name);
            } else {
                footer.disableButton(SAVE_BUTTON.name);
            }
        }
    }

    async queryIssueStatus() {
        console.log(this.name + ' queryIssueStatus()');
        const query = Database.queryBuilder(ISSUE_STATUS_OBJ.objectApiName, Object.values(ISSUE_STATUS_FIELDS));
        query.addWhereCondition(ISSUE_STATUS_FIELDS.Id, '=', this.statusId);
        try {
            const result = await Database.query(query);
            if (result && result.length > 0) {
                this.status = Database.createSObject(ISSUE_STATUS_OBJ.objectApiName, result[0]);
                this.changeToLookup.where = [{
                    field: ISSUE_STATUS_FIELDS.Project,
                    operator: '=',
                    value: this.status.fields[ISSUE_STATUS_FIELDS.Project],
                }];
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }

    async queryIssueStatusOrder() {
        console.log(this.name + ' queryIssueStatusOrder()');
        const query = Database.queryBuilder(ISSUE_STATUS_ORDER_OBJ.objectApiName, Object.values(ISSUE_STATUS_ORDER_FIELDS));
        query.addWhereCondition(ISSUE_STATUS_ORDER_FIELDS.Id, '=', this.recordId);
        try {
            const result = await Database.query(query);
            if (result && result.length > 0) {
                this.record = Database.createSObject(ISSUE_STATUS_ORDER_OBJ.objectApiName, result[0]);
                this.record.fields[ISSUE_STATUS_ORDER_FIELDS.StatusId] = this.statusId;
                this.title = LABELS.Edit + ' ' + this.record.fields[ISSUE_STATUS_ORDER_FIELDS.Name];
                this.assignedToLookup.disabled = this.record.fields[ISSUE_STATUS_ORDER_FIELDS.ToLastAssingment];
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }
}