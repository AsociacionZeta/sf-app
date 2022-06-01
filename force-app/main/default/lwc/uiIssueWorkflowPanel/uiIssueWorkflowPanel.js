import { LightningElement, api, track } from 'lwc';
import UserInfo from 'c/classUserInfo';
import SchemaUtils from 'c/classSchemaUtils';
import Database from 'c/classDatabase';
import ErrorManager from 'c/classErrorManager';
import EventManager from 'c/classEventManager';
import QuickActionUtils from 'c/classQuickActionUtils';
import DOMUtils from 'c/classDOMUtils';

// LABELS IMPORT
import WORKFLOW_LBL from '@salesforce/label/c.Workflow';
import SAVE_LBL from '@salesforce/label/c.Save';
import CANCE_LBL from '@salesforce/label/c.Cancel';
import RESOLUTION_LBL from '@salesforce/label/c.Resolution';
import COMMENT_LBL from '@salesforce/label/c.Comment';
import COMMENT_REQUIRED_ERROR_LBL from '@salesforce/label/c.CommentRequiredError';
import ASSIGNED_TO_LBL from '@salesforce/label/c.AssignedTo';


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
import ISSUE_PROJECT_MANAGER_FIELD from '@salesforce/schema/Issue__c.Project__r.Manager__c';
import ISSUE_RECORD_TYPE_FIELD from '@salesforce/schema/Issue__c.RecordTypeId';
import ISSUE_SPRINT_FIELD from '@salesforce/schema/Issue__c.Sprint__c';
import ISSUE_STATUS_FIELD from '@salesforce/schema/Issue__c.Status__c';
import ISSUE_STATUS_TYPE_FIELD from '@salesforce/schema/Issue__c.Status__r.Type__c';
import ISSUE_RESOLUTION_FIELD from '@salesforce/schema/Issue__c.Resolution__c';

// ISSUE STATUS ORDER SCHEMA IMPORTS
import ISSUE_STATUS_ORDER_OBJ from '@salesforce/schema/IssueStatusOrder__c';
import ISSUE_STATUS_ORDER_ID_FIELD from '@salesforce/schema/IssueStatusOrder__c.Id';
import ISSUE_STATUS_ORDER_NAME_FIELD from '@salesforce/schema/IssueStatusOrder__c.Name';
import ISSUE_STATUS_ORDER_ASSIGN_TO_FIELD from '@salesforce/schema/IssueStatusOrder__c.AssignTo__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_TYPE_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.Type__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_ICON_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.Icon__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_COMMENT_REQUIRED_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.CommentRequired__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_BUTTON_NAME_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.ButtonName__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_BUTTON_ORDER_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.ButtonOrder__c';
import ISSUE_STATUS_ORDER_CHANGE_TO_BUTTON_VARIANT_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.ButtonVariant__c';
import ISSUE_STATUS_ORDER_CHANGE_ACTIVE_FIELD from '@salesforce/schema/IssueStatusOrder__c.ChangeTo__r.Active__c';
import ISSUE_STATUS_ORDER_STATUS_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__c';
import ISSUE_STATUS_ORDER_STATUS_TYPE_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__r.Type__c';
import ISSUE_STATUS_ORDER_STATUS_ICON_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__r.Icon__c';
import ISSUE_STATUS_ORDER_STATUS_COMMENT_REQUIRED_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__r.CommentRequired__c';
import ISSUE_STATUS_ORDER_STATUS_BUTTON_NAME_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__r.ButtonName__c';
import ISSUE_STATUS_ORDER_STATUS_BUTTON_ORDER_FIELD from '@salesforce/schema/IssueStatusOrder__c.Status__r.ButtonOrder__c';
import ISSUE_STATUS_ORDER_LAST_ASSIGNMENT_FIELD from '@salesforce/schema/IssueStatusOrder__c.ToLastAssignment__c';

// ISSUE COMMENT IMPORTS
import ISSUE_COMMENT_OBJ from '@salesforce/schema/IssueComment__c';
import ISSUE_COMMENT_ID_FIELD from '@salesforce/schema/IssueComment__c.Id';
import ISSUE_COMMENT_BODY_FIELD from '@salesforce/schema/IssueComment__c.Body__c';
import ISSUE_COMMENT_ISSUE_FIELD from '@salesforce/schema/IssueComment__c.Issue__c';

const LABELS = {
    Workflow: WORKFLOW_LBL,
    Save: SAVE_LBL,
    Cancel: CANCE_LBL,
    Resolution: RESOLUTION_LBL,
    Comment: COMMENT_LBL,
    CommentRequiredError: COMMENT_REQUIRED_ERROR_LBL,
    AssignedTo: ASSIGNED_TO_LBL,
};

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
    ProjectManager: ISSUE_PROJECT_MANAGER_FIELD.fieldApiName,
    RecordTypeId: ISSUE_RECORD_TYPE_FIELD.fieldApiName,
    Sprint: ISSUE_SPRINT_FIELD.fieldApiName,
    StatusId: ISSUE_STATUS_FIELD.fieldApiName,
    StatusType: ISSUE_STATUS_TYPE_FIELD.fieldApiName,
    Resolution: ISSUE_RESOLUTION_FIELD.fieldApiName,
};

const ISSUE_STATUS_ORDER_FIELDS = {
    Id: ISSUE_STATUS_ORDER_ID_FIELD.fieldApiName,
    Name: ISSUE_STATUS_ORDER_NAME_FIELD.fieldApiName,
    AssignToId: ISSUE_STATUS_ORDER_ASSIGN_TO_FIELD.fieldApiName,
    ChangeToId: ISSUE_STATUS_ORDER_CHANGE_TO_FIELD.fieldApiName,
    ChangeToType: ISSUE_STATUS_ORDER_CHANGE_TO_TYPE_FIELD.fieldApiName,
    ChangeToIcon: ISSUE_STATUS_ORDER_CHANGE_TO_ICON_FIELD.fieldApiName,
    ChangeToCommentRequired: ISSUE_STATUS_ORDER_CHANGE_TO_COMMENT_REQUIRED_FIELD.fieldApiName,
    ChangeToButtonName: ISSUE_STATUS_ORDER_CHANGE_TO_BUTTON_NAME_FIELD.fieldApiName,
    ChangeToButtonOrder: ISSUE_STATUS_ORDER_CHANGE_TO_BUTTON_ORDER_FIELD.fieldApiName,
    ChangeToButtonVariant: ISSUE_STATUS_ORDER_CHANGE_TO_BUTTON_VARIANT_FIELD.fieldApiName,
    ChangeToActive: ISSUE_STATUS_ORDER_CHANGE_ACTIVE_FIELD.fieldApiName,
    StatusId: ISSUE_STATUS_ORDER_STATUS_FIELD.fieldApiName,
    StatusType: ISSUE_STATUS_ORDER_STATUS_TYPE_FIELD.fieldApiName,
    StatusIcon: ISSUE_STATUS_ORDER_STATUS_ICON_FIELD.fieldApiName,
    StatusCommentRequired: ISSUE_STATUS_ORDER_STATUS_COMMENT_REQUIRED_FIELD.fieldApiName,
    StatusButtonName: ISSUE_STATUS_ORDER_STATUS_BUTTON_NAME_FIELD.fieldApiName,
    StatusButtonOrder: ISSUE_STATUS_ORDER_STATUS_BUTTON_ORDER_FIELD.fieldApiName,
    ToLastAssingment: ISSUE_STATUS_ORDER_LAST_ASSIGNMENT_FIELD.fieldApiName,
};

const ISSUE_COMMENT_FIELDS = {
    Id: ISSUE_COMMENT_ID_FIELD.fieldApiName,
    Body: ISSUE_COMMENT_BODY_FIELD.fieldApiName,
    Issue: ISSUE_COMMENT_ISSUE_FIELD.fieldApiName,
};

export default class IssueWorkflowPanel extends LightningElement {

    @api name = 'IssueWorkflowPanel';
    @api recordId;

    @track allowWorkflow = true;
    @track issue;
    @track issueStatusOrders = [];
    @track buttons = [];
    @track showDialog = false;
    @track resolutionOptions = [];
    @track dialog = {
        title: '',
        index: 0,
        showResolution: false,
        buttons: [],
    };

    issueComment = Database.createSObject(ISSUE_COMMENT_OBJ.objectApiName);
    issueCommentFields = ISSUE_COMMENT_FIELDS;
    labels = LABELS;
    issueFields = ISSUE_FIELDS;
    currentUser;

    async connectedCallback() {
        console.log(this.name + ' connectedCallback()');
        this.allowWorkflow = true;
        this.currentUser = await UserInfo.getCurrentUser();
        await this.queryIssue();
        if (!UserInfo.isAdmin(this.currentUser)) {
            const allowedIds = [
                this.issue.fields[ISSUE_FIELDS.AssignedTo],
                this.issue.fields[ISSUE_FIELDS.OpenedBy],
                SchemaUtils.getSObjectFieldValue(this.issue, ISSUE_FIELDS.ProjectManager)
            ];
            this.allowWorkflow = !allowedIds.includes(this.currentUser.Id);
        }
        await this.queryIssueStatusOrder();
        if (this.issueStatusOrders) {
            for (const issueStatusOrder of this.issueStatusOrders) {
                this.buttons.push({
                    label: SchemaUtils.getSObjectFieldValue(issueStatusOrder, ISSUE_STATUS_ORDER_FIELDS.ChangeToButtonName) || issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.Name],
                    title: issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.Name],
                    value: issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.Id],
                    variant: SchemaUtils.getSObjectFieldValue(issueStatusOrder, ISSUE_STATUS_ORDER_FIELDS.ChangeToButtonVariant) || 'neutral',
                    disabled: !this.allowWorkflow,
                });
            }
        }
    }

    async handleClick(event) {
        console.log(this.name + ' handleClick()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        if (source === 'footer') {
            if (detail.button === LABELS.Save) {
                const issueStatusOrder = this.issueStatusOrders[this.dialog.index];
                this.issue.fields[ISSUE_FIELDS.StatusId] = issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.ChangeToId];
                Database.update(this.issue).then(issueResult => {
                    this.issueComment.fields[ISSUE_COMMENT_FIELDS.Issue] = this.issue.fields[ISSUE_FIELDS.Id];
                    if(this.issueComment){
                        Database.insert(this.issueComment).then(commentResult => {
                            this.issueComment = Database.createSObject(ISSUE_COMMENT_OBJ.objectApiName);
                            window.location.reload();
                        });
                    }
                });
                this.showDialog = false;
            } else {
                this.showDialog = false;
            }
        } else {
            const issueStatusOrder = this.issueStatusOrders[dataset.index];
            if (issueStatusOrder) {
                if (SchemaUtils.getSObjectFieldValue(issueStatusOrder, ISSUE_STATUS_ORDER_FIELDS.ChangeToCommentRequired)) {
                    await this.getResolutions();
                    this.dialog = {
                        title: issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.Name],
                        index: dataset.index,
                        showResolution: false,
                        buttons: [],
                    };
                    this.dialog.title = issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.Name];
                    this.dialog.buttons.push({
                        name: LABELS.Save,
                        label: LABELS.Save,
                        title: LABELS.Save,
                        variant: 'brand',
                        disabled: true,
                    });
                    this.dialog.buttons.push({
                        name: LABELS.Cancel,
                        label: LABELS.Cancel,
                        title: LABELS.Cancel,
                        variant: 'neutral'
                    });
                    this.dialog.showResolution = SchemaUtils.getSObjectFieldValue(issueStatusOrder, ISSUE_STATUS_ORDER_FIELDS.ChangeToType) === 'closed';
                    this.showDialog = true;
                } else {
                    this.issue.fields[ISSUE_FIELDS.StatusId] = issueStatusOrder.fields[ISSUE_STATUS_ORDER_FIELDS.ChangeToId];
                    Database.update(this.issue).then(result => {
                        window.location.reload();
                    });
                }
            }
        }
    }

    handleChange(event) {
        console.log(this.name + ' handleChange()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const issueFieldNames = Object.values(ISSUE_FIELDS);
        const issueCommentFieldNames = Object.values(ISSUE_COMMENT_FIELDS);
        if (issueFieldNames.includes(source)) {
            this.issue.fields[source] = detail.value;
        } else if (issueCommentFieldNames.includes(source)) {
            this.issueComment.fields[source] = detail.value;
        }
        this.validate();
    }

    handleSelect(event) {
        console.log(this.name + ' handleSelect()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const issueFieldNames = Object.values(ISSUE_FIELDS);
        if (issueFieldNames.includes(source)) {
            this.issue.fields[source] = detail.value;
        }
        this.validate();
    }

    handleRemove(event) {
        console.log(this.name + ' handleRemove()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const dataset = EventManager.getEventDataset(event);
        const issueFieldNames = Object.values(ISSUE_FIELDS);
        if (issueFieldNames.includes(source)) {
            this.issue.fields[source] = undefined;
        }
        this.validate();
    }

    validate() {
        const footerInput = DOMUtils.queryByDataName(this, 'footer');
        if (footerInput) {
            if (!this.issueComment.fields[ISSUE_COMMENT_FIELDS.Body]) {
                footerInput.disableButton(LABELS.Save);
            } else {
                footerInput.enableButton(LABELS.Save);
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
                this.issue = Database.createSObject(ISSUE_OBJ.objectApiName, result[0]);
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }

    async queryIssueStatusOrder() {
        console.log(this.name + ' queryIssueStatusOrder()');
        const issueStatusOrderQuery = Database.queryBuilder(ISSUE_STATUS_ORDER_OBJ.objectApiName, Object.values(ISSUE_STATUS_ORDER_FIELDS));
        issueStatusOrderQuery.addWhereCondition(ISSUE_STATUS_ORDER_FIELDS.StatusId, '=', this.issue.fields[ISSUE_FIELDS.StatusId]);
        issueStatusOrderQuery.addWhereCondition(ISSUE_STATUS_ORDER_FIELDS.ChangeToActive, '=', true);
        issueStatusOrderQuery.createOrderBy([ISSUE_STATUS_ORDER_FIELDS.ChangeToButtonOrder], 'ASC')
        try {
            const result = await Database.query(issueStatusOrderQuery);
            this.issueStatusOrders = [];
            if (result && result.length > 0) {
                for (const record of result) {
                    this.issueStatusOrders.push(Database.createSObject(ISSUE_STATUS_ORDER_OBJ.objectApiName, record));
                }
            }
        } catch (error) {
            const err = ErrorManager.getError(error);
            console.log(err);
        }
    }

    async getResolutions() {
        console.log(this.name + ' getResolutions()');
        const resolutions = await SchemaUtils.getPicklistValues(ISSUE_OBJ.objectApiName, ISSUE_FIELDS.Resolution);
        this.resolutionOptions = [];
        for (const resolution of resolutions) {
            if (resolution.active) {
                this.resolutionOptions.push({
                    value: resolution.value,
                    label: resolution.label,
                });
            }
        }
    }

}