// LIBRARIES IMPORT
import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Database from 'c/classDatabase';
import ToastManager from 'c/classToastManager';
import ErrorManager from 'c/classErrorManager';
import EventManager from 'c/classEventManager';
import CoreUtils from 'c/classCoreUtils';
import StrUtils from 'c/classStrUtils';
import QuickActionUtils from 'c/classQuickActionUtils';
import UserInfo from 'c/classUserInfo';
import SchemaUtils from 'c/classSchemaUtils';
import URLUtils from 'c/classURLUtils';
import DOMUtils from 'c/classDOMUtils';
import Validator from 'c/classValidator';
import DateTimeUtils from 'c/classDateTimeUtils';
import NavigationService from 'c/classNavigationService';

// LABELS IMPORT
import SAVE_LBL from '@salesforce/label/c.Save';
import CANCE_LBL from '@salesforce/label/c.Cancel';
import NEW_ISSUE_LBL from '@salesforce/label/c.NewIssue';
import EDIT_LBL from '@salesforce/label/c.Edit';
import HEADLINE_LBL from '@salesforce/label/c.Headline';
import DESCRIPTION_LBL from '@salesforce/label/c.Description';
import RECORD_TYPE_ICON_LBL from '@salesforce/label/c.RecordTypeIcon';
import RECORD_TYPE_LBL from '@salesforce/label/c.RecordType';
import PROJECT_LBL from '@salesforce/label/c.Project';
import REQUIRED_PROJECT_ERROR_LBL from '@salesforce/label/c.RequiredProjectError';
import START_DATE_LBL from '@salesforce/label/c.StartDate';
import ASSIGNED_TO_LBL from '@salesforce/label/c.AssignedTo';
import ASSIGN_TO_ME_LBL from '@salesforce/label/c.AssignToMe';
import ISSUE_OPENED_BY_ERROR_LBL from '@salesforce/label/c.IssueOpenedByError';
import ERROR_LBL from '@salesforce/label/c.Error';
import REQUIRED_ASSIGNED_TO_ERROR_LBL from '@salesforce/label/c.RequiredAssignedToError';
import PARENT_ISSUE_LBL from '@salesforce/label/c.ParentIssue';
import PRIORITY_LBL from '@salesforce/label/c.Priority';
import SPRINT_LBL from '@salesforce/label/c.Sprint';
import ESTIMATED_TIME_LBL from '@salesforce/label/c.EstimatedTime';
import REQUIRED_ESTIMATED_TIME_ERROR_LBL from '@salesforce/label/c.RequiredEstimatedTimeError';
import WRONG_ESTIMATED_TIME_FORMAT_ERROR_LBL from '@salesforce/label/c.WrongEstimatedTimeFormatError';
import STATUS_LBL from '@salesforce/label/c.Status';
import RESOLUTION_LBL from '@salesforce/label/c.Resolution';

// ISSUE SCHEMA IMPORTS
import ISSUE_OBJ from '@salesforce/schema/Issue__c';
import ISSUE_ID_FIELD from '@salesforce/schema/Issue__c.Id';
import ISSUE_NAME_FIELD from '@salesforce/schema/Issue__c.Name';
import ISSUE_HEADLINE_FIELD from '@salesforce/schema/Issue__c.Headline__c';
import ISSUE_DESCRIPTION_FIELD from '@salesforce/schema/Issue__c.Description__c';
import ISSUE_START_DATE_FIELD from '@salesforce/schema/Issue__c.StartDate__c';
import ISSUE_END_DATE_FIELD from '@salesforce/schema/Issue__c.EndDate__c';
import ISSUE_ESTIMATED_TIME_FIELD from '@salesforce/schema/Issue__c.EstimatedTime__c';
import ISSUE_REMAINING_TIME_FIELD from '@salesforce/schema/Issue__c.RemainingTime__c';
import ISSUE_LOGGED_TIME_FIELD from '@salesforce/schema/Issue__c.LoggedTime__c';
import ISSUE_PARENT_ISSUE_FIELD from '@salesforce/schema/Issue__c.ParentIssue__c';
import ISSUE_ASSIGNED_TO_FIELD from '@salesforce/schema/Issue__c.AssignedTo__c';
import ISSUE_OPENED_BY_FIELD from '@salesforce/schema/Issue__c.OpenedBy__c';
import ISSUE_PRIORITY_FIELD from '@salesforce/schema/Issue__c.Priority__c';
import ISSUE_PROJECT_FIELD from '@salesforce/schema/Issue__c.Project__c';
import ISSUE_RECORD_TYPE_FIELD from '@salesforce/schema/Issue__c.RecordTypeId';
import ISSUE_SPRINT_FIELD from '@salesforce/schema/Issue__c.Sprint__c';
import ISSUE_RESOLUTION_FIELD from '@salesforce/schema/Issue__c.Resolution__c';
import ISSUE_STATUS_FIELD from '@salesforce/schema/Issue__c.Status__c';

// PROJECT SCHEMA IMPORTS
import PROJECT_OBJ from '@salesforce/schema/Project__c';
import PROJECT_ID_FIELD from '@salesforce/schema/Project__c.Id';
import PROJECT_NAME_FIELD from '@salesforce/schema/Project__c.Name';


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

// SPRINT SCHEMA IMPORTS
import SPRINT_OBJ from '@salesforce/schema/Sprint__c';
import SPRINT_ID_FIELD from '@salesforce/schema/Sprint__c.Id';
import SPRINT_NAME_FIELD from '@salesforce/schema/Sprint__c.Name';
import SPRINT_PROJECT_FIELD from '@salesforce/schema/Sprint__c.Project__c';

const LABELS = {
    Save: SAVE_LBL,
    Cancel: CANCE_LBL,
    NewIssue: NEW_ISSUE_LBL,
    Edit: EDIT_LBL,
    Headline: HEADLINE_LBL,
    Description: DESCRIPTION_LBL,
    RecordType: RECORD_TYPE_LBL,
    RecordTypeIcon: RECORD_TYPE_ICON_LBL,
    Project: PROJECT_LBL,
    RequiredProjectError: REQUIRED_PROJECT_ERROR_LBL,
    StartDate: START_DATE_LBL,
    AssignedTo: ASSIGNED_TO_LBL,
    AssignToMe: ASSIGN_TO_ME_LBL,
    IssueOpenedByError: ISSUE_OPENED_BY_ERROR_LBL,
    Error: ERROR_LBL,
    RequiredAssignedToError: REQUIRED_ASSIGNED_TO_ERROR_LBL,
    ParentIssue: PARENT_ISSUE_LBL,
    Priority: PRIORITY_LBL,
    Sprint: SPRINT_LBL,
    EstimatedTime: ESTIMATED_TIME_LBL,
    RequiredEstimatedTimeError: REQUIRED_ESTIMATED_TIME_ERROR_LBL,
    WrongEstimatedTimeFormatError: WRONG_ESTIMATED_TIME_FORMAT_ERROR_LBL,
    Status: STATUS_LBL,
    Resolution: RESOLUTION_LBL,
};

const PROJECT_FIELDS = [
    PROJECT_ID_FIELD.fieldApiName,
    PROJECT_NAME_FIELD.fieldApiName,
];

const CONTACT_FIELDS = [
    CONTACT_ID_FIELD.fieldApiName,
    CONTACT_NAME_FIELD.fieldApiName,
];

const SPRINT_FIELDS = [
    SPRINT_ID_FIELD.fieldApiName,
    SPRINT_NAME_FIELD.fieldApiName,
    SPRINT_PROJECT_FIELD.fieldApiName,
];

const PROJECT_COLLABORATOR_FIELDS = [
    PROJECT_COLLABORATOR_ID_FIELD.fieldApiName,
    PROJECT_COLLABORATOR_NAME_FIELD.fieldApiName,
    PROJECT_COLLABORATOR_CONTACT_FIELD.fieldApiName,
    PROJECT_COLLABORATOR_CONTACT_ID_FIELD.fieldApiName,
    PROJECT_COLLABORATOR_CONTACT_NAME_FIELD.fieldApiName,
    PROJECT_COLLABORATOR_PROJECT_FIELD.fieldApiName,
    PROJECT_COLLABORATOR_CONTACT_USER_FIELD.fieldApiName,
];

const ISSUE_FIELDS = {
    Id: ISSUE_ID_FIELD.fieldApiName,
    Name: ISSUE_NAME_FIELD.fieldApiName,
    Headline: ISSUE_HEADLINE_FIELD.fieldApiName,
    Description: ISSUE_DESCRIPTION_FIELD.fieldApiName,
    StartDate: ISSUE_START_DATE_FIELD.fieldApiName,
    EndDate: ISSUE_END_DATE_FIELD.fieldApiName,
    EstimatedTime: ISSUE_ESTIMATED_TIME_FIELD.fieldApiName,
    RemainingTime: ISSUE_REMAINING_TIME_FIELD.fieldApiName,
    LoggedTime: ISSUE_LOGGED_TIME_FIELD.fieldApiName,
    ParentIssue: ISSUE_PARENT_ISSUE_FIELD.fieldApiName,
    AssignedTo: ISSUE_ASSIGNED_TO_FIELD.fieldApiName,
    OpenedBy: ISSUE_OPENED_BY_FIELD.fieldApiName,
    Priority: ISSUE_PRIORITY_FIELD.fieldApiName,
    Project: ISSUE_PROJECT_FIELD.fieldApiName,
    RecordTypeId: ISSUE_RECORD_TYPE_FIELD.fieldApiName,
    Sprint: ISSUE_SPRINT_FIELD.fieldApiName,
    Resolution: ISSUE_RESOLUTION_FIELD.fieldApiName,
    Status: ISSUE_STATUS_FIELD.fieldApiName
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
    variant: 'brand'
};

const ASSING_TO_ME_BUTTON = {
    name: "assignToMe",
    label: LABELS.AssignToMe,
    title: LABELS.AssignToMe,
    variant: 'brand-outline'
};

const RT_ICONS = {
    'History': 'standard:entitlement_policy',
    'Bug': 'standard:incident',
    'Documentation': 'standard:drafts',
    'Investigation': 'standard:search',
}

const PRIORITY_ICONS = {
    'Critical': 'custom:custom34',
    'High': 'custom:custom19',
    'Medium': 'custom:custom3',
    'Low': 'custom:custom44',
}

export default class NewIssue extends NavigationMixin(LightningElement) {

    @api name = 'NewIssue';
    @api recordId;
    @api projectId;
    @api parentIssueId;

    @track currentUser;
    @track loading = true;
    @track resizable = true;
    @track loadingTitle;
    @track loadingMessage;
    @track buttons = [CANCEL_BUTTON, SAVE_BUTTON];
    @track record = Database.createSObject(ISSUE_OBJ.objectApiName);
    @track title;
    @track userContactId;
    @track projectLookup = {
        obj: PROJECT_OBJ.objectApiName,
        iconName: 'standard:task',
        where: [],
        fields: PROJECT_FIELDS,
    };
    @track assignedToLookup = {
        obj: CONTACT_OBJ.objectApiName,
        iconName: 'standard:people',
        where: [],
        fields: CONTACT_FIELDS,
    };
    @track parentIssueLookup = {
        obj: ISSUE_OBJ.objectApiName,
        iconName: 'standard:task2',
        where: [],
        fields: Object.values(ISSUE_FIELDS),
    };
    @track sprintLookup = {
        obj: SPRINT_OBJ.objectApiName,
        iconName: 'standard:goals',
        where: [],
        fields: SPRINT_FIELDS,
    };
    @track sprintDisabled = false;
    @track parentIssueDisabled = false;
    @track assignToDisabled = false;
    @track assignToMeBtn = ASSING_TO_ME_BUTTON;
    @track assignedToOptions = [];
    @track issueFields = ISSUE_FIELDS;
    @track editMode = false;
    @track recordTypeOptions = [];
    @track priorityOptions = [];
    @track resolutionOptions = [];
    @track statusOptions = [];

    labels = LABELS;
    recordTypes = [];
    priorities = [];
    resolutions = [];
    statuses = [];

    async connectedCallback() {
        console.log(this.name + ' connectedCallback()');
        this.getContextData();
        this.editMode = this.recordId !== undefined;
        this.currentUser = await UserInfo.getUserInfo();
        await this.queryContactCollaboration();
        if (this.userContactId) {
            await this.getRecordTypes();
            await this.getPriorities();
            if (this.editMode) {
                await this.getStatuses();
                await this.getResolutions();
                await this.queryIssue();
                this.sprintDisabled = false;
                this.parentIssueDisabled = false;
                this.assignToDisabled = false;
                this.loading = false;
            } else {
                this.title = LABELS.NewIssue;
                this.record.fields[ISSUE_FIELDS.OpenedBy] = this.userContactId;
                this.record.fields[ISSUE_FIELDS.Status] = 'Opened';
                this.record.fields[ISSUE_FIELDS.StartDate] = new Date().toISOString().split('T')[0];
                this.loading = false;
            }
            if (!this.record.fields[ISSUE_FIELDS.Project]) {
                this.sprintDisabled = true;
                this.parentIssueDisabled = true;
                this.assignToDisabled = true;
            } else {
                await this.queryProjectCollaborators();
            }
            this.validate();
        } else {
            this.loading = false;
            this.buttons = [CANCEL_BUTTON];
            ToastManager.showErrorToast(this, LABELS.Error, LABELS.IssueOpenedByError);
        }
        console.log(this.record);
    }

    handleResize(event) {
        console.log(this.name + ' handleResize()');
        const detail = EventManager.getEventDetail(event);
        QuickActionUtils.resize(this, detail.style);
    }

    async handleClick(event) {
        console.log(this.name + ' handleClick()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        if (source === 'footer') {
            if (detail.button === SAVE_BUTTON.name) {
                this.loading = true;
                this.record.fields[ISSUE_FIELDS.EstimatedTime] = DateTimeUtils.durationStringToMinutes(this.record.fields[ISSUE_FIELDS.EstimatedTime]);
                if (this.editMode) {
                    this.record = await Database.update(this.record);
                } else {
                    this.record = await Database.insert(this.record);
                }
                this.record = Database.createSObject(ISSUE_OBJ.objectApiName, this.record);
                // NavigationService.goToRecordPage(this, this.record.fields[ISSUE_FIELDS.Id], true);
                window.history.back();
            } else if (detail.button === CANCEL_BUTTON.name) {
                window.history.back();
            }
        } else if (source === ASSING_TO_ME_BUTTON.name) {
            this.record.fields[ISSUE_FIELDS.AssignedTo] = this.userContactId;
            this.assignedToLookup.where = [];
            this.validate();
        }
    }

    async handleSelect(event) {
        console.log(this.name + ' handleSelect()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const fields = Object.values(ISSUE_FIELDS);
        if (fields.includes(source)) {
            if (detail.value.Id) {
                this.record.fields[source] = detail.value.Id;
                if (source === ISSUE_FIELDS.Project) {
                    await this.queryProjectCollaborators();
                    this.parentIssueLookup.where = [{
                        field: ISSUE_FIELDS.Project,
                        operator: '=',
                        value: this.record.fields[ISSUE_FIELDS.Project],
                    }];
                    this.sprintLookup.where = [{
                        field: SPRINT_PROJECT_FIELD.fieldApiName,
                        operator: '=',
                        value: this.record.fields[ISSUE_FIELDS.Project],
                    }];
                    this.assignToDisabled = false;
                    this.parentIssueDisabled = false;
                    this.sprintDisabled = false;
                }
            } else {
                this.record.fields[source] = detail.value;
            }
        }
        this.validate();
    }

    handleRemove(event) {
        console.log(this.name + ' handleRemove()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const fields = Object.values(ISSUE_FIELDS);
        if (fields.includes(source)) {
            this.record.fields[source] = undefined;
            if (source === ISSUE_FIELDS.Project) {
                this.assignToDisabled = true;
                this.parentIssueDisabled = true;
                this.sprintDisabled = true;
                this.record.fields[ISSUE_FIELDS.AssignedTo] = undefined;
            }
        }
        this.validate();
    }

    handleChange(event) {
        console.log(this.name + ' handleChange()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const fields = Object.values(ISSUE_FIELDS);
        if (fields.includes(source)) {
            this.record.fields[source] = detail.value;
        }
        this.validate();
    }

    getContextData() {
        console.log(this.name + ' getContextData()');
        const contextData = URLUtils.getContextOfRefData();
        if (contextData && contextData.attributes) {
            if (contextData.attributes.objectApiName === PROJECT_OBJ.objectApiName) {
                this.projectId = contextData.attributes.recordId;
                this.record.fields[ISSUE_FIELDS.Project] = this.projectId;
                this.parentIssueLookup.where = [{
                    field: ISSUE_FIELDS.Project,
                    operator: '=',
                    value: this.record.fields[ISSUE_FIELDS.Project],
                }];
                this.sprintLookup.where = [{
                    field: SPRINT_PROJECT_FIELD.fieldApiName,
                    operator: '=',
                    value: this.record.fields[ISSUE_FIELDS.Project],
                }];
            } else if (contextData.attributes.objectApiName === ISSUE_OBJ.objectApiName) {
                this.parentIssueId = contextData.attributes.recordId;
                this.record.fields[ISSUE_FIELDS.ParentIssue] = this.parentIssueId;
            }
        }
    }

    validate() {
        const requiredFields = [
            ISSUE_FIELDS.Headline,
            ISSUE_FIELDS.Description,
            ISSUE_FIELDS.RecordTypeId,
            ISSUE_FIELDS.Project,
            ISSUE_FIELDS.AssignedTo,
            ISSUE_FIELDS.StartDate,
            ISSUE_FIELDS.EstimatedTime,
            ISSUE_FIELDS.Priority,
        ];
        if(this.editMode){
            requiredFields.push(ISSUE_FIELDS.Status);
        }
        let valid = true;
        const footer = DOMUtils.queryByDataName(this, 'footer');
        for (const field of requiredFields) {
            if (!this.record.fields[field]) {
                valid = false;
            }
        }
        if (this.record.fields[ISSUE_FIELDS.EstimatedTime]) {
            const estimatedTime = DOMUtils.queryByDataName(this, ISSUE_FIELDS.EstimatedTime);
            if (estimatedTime) {
                if (!Validator.isDuration(this.record.fields[ISSUE_FIELDS.EstimatedTime])) {
                    estimatedTime.setCustomValidity(LABELS.WrongEstimatedTimeFormatError);
                    valid = false;
                } else {
                    estimatedTime.setCustomValidity('');
                }
                estimatedTime.reportValidity();
            }
        }
        if (footer) {
            if (valid) {
                footer.enableButton(SAVE_BUTTON.name);
            } else {
                footer.disableButton(SAVE_BUTTON.name);
            }
        }
    }

    async queryIssue() {
        console.log(this.name + ' queryIssue()');
        const issueQuery = Database.queryBuilder(ISSUE_OBJ.objectApiName, Object.values(ISSUE_FIELDS));
        issueQuery.addWhereCondition(ISSUE_ID_FIELD.fieldApiName, '=', this.recordId);
        try {
            const result = await Database.query(issueQuery);
            if (result && result.length > 0) {
                this.record = Database.createSObject(ISSUE_OBJ.objectApiName, result[0]);
                this.record.fields[ISSUE_FIELDS.EstimatedTime] = DateTimeUtils.minutesToDurationString(this.record.fields[ISSUE_FIELDS.EstimatedTime], true);
                this.title = LABELS.Edit + ' ' + this.record.fields.Name;
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }

    async getRecordTypes() {
        console.log(this.name + ' getRecordTypes()');
        const recordTypes = await SchemaUtils.describeRecordTypes(ISSUE_OBJ.objectApiName);
        this.recordTypes = Object.values(recordTypes);
        for (const rt of this.recordTypes) {
            if (rt.active && rt.available && !rt.master) {
                this.recordTypeOptions.push({
                    value: rt.recordTypeId,
                    label: rt.name,
                    iconName: RT_ICONS[rt.devName],
                    altText: LABELS.RecordTypeIcon,
                });
            }
        }
    }

    async queryContactCollaboration() {
        console.log(this.name + ' getProjectCollaborators()');
        const pcQuery = Database.queryBuilder(PROJECT_COLLABORATOR_OBJ.objectApiName, PROJECT_COLLABORATOR_FIELDS);
        pcQuery.addWhereCondition(PROJECT_COLLABORATOR_CONTACT_USER_FIELD.fieldApiName, '=', this.currentUser.Id);
        try {
            const result = await Database.query(pcQuery);
            const projectIds = [];
            for (const record of result) {
                if (this.currentUser.Id === SchemaUtils.getSObjectFieldValue(record, PROJECT_COLLABORATOR_CONTACT_USER_FIELD.fieldApiName)) {
                    this.userContactId = record[PROJECT_COLLABORATOR_CONTACT_FIELD.fieldApiName];
                    projectIds.push(record[PROJECT_COLLABORATOR_PROJECT_FIELD.fieldApiName]);
                }
            }
            if (projectIds.length > 0) {
                this.projectLookup.where = [{
                    field: PROJECT_ID_FIELD.fieldApiName,
                    operator: 'in',
                    value: projectIds
                }];
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }

    async queryProjectCollaborators() {
        console.log(this.name + ' queryAssignedTo()');
        const pcQuery = Database.queryBuilder(PROJECT_COLLABORATOR_OBJ.objectApiName, PROJECT_COLLABORATOR_FIELDS);
        pcQuery.addWhereCondition(PROJECT_COLLABORATOR_PROJECT_FIELD.fieldApiName, '=', this.record.fields[ISSUE_FIELDS.Project]);
        try {
            const result = await Database.query(pcQuery);
            const contactIds = [];
            for (const record of result) {
                contactIds.push(record[PROJECT_COLLABORATOR_CONTACT_FIELD.fieldApiName]);
            }
            if (contactIds.length > 0) {
                this.assignedToLookup.where = [{
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

    async getPriorities() {
        console.log(this.name + ' getPriorities()');
        this.priorities = await SchemaUtils.getPicklistValues(ISSUE_OBJ.objectApiName, ISSUE_FIELDS.Priority);
        for (const priority of this.priorities) {
            if (priority.active) {
                this.priorityOptions.push({
                    value: priority.value,
                    label: priority.label,
                    iconName: PRIORITY_ICONS[priority.value],
                    altText: LABELS.Priority,
                });
            }
        }
    }

    async getResolutions() {
        console.log(this.name + ' getResolutions()');
        this.resolutions = await SchemaUtils.getPicklistValues(ISSUE_OBJ.objectApiName, ISSUE_FIELDS.Resolution);
        for (const resolution of this.resolutions) {
            if (resolution.active) {
                this.resolutionOptions.push({
                    value: resolution.value,
                    label: resolution.label,
                });
            }
        }
    }

    async getStatuses() {
        console.log(this.name + ' getStatuses()');
        this.statuses = await SchemaUtils.getPicklistValues(ISSUE_OBJ.objectApiName, ISSUE_FIELDS.Status);
        for (const status of this.statuses) {
            if (status.active) {
                this.statusOptions.push({
                    value: status.value,
                    label: status.label,
                });
            }
        }
    }
}