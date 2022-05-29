import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import Database from 'c/classDatabase';
import NavigationService from 'c/classNavigationService';
import EventManager from 'c/classEventManager';
import SchemaUtils from 'c/classSchemaUtils';
import StrUtils from 'c/classStrUtils';

// LABELS IMPORT
import SEARCH_LBL from '@salesforce/label/c.Search';
import NOT_RECORDS_FOUND_LBL from '@salesforce/label/c.NotRecordsFound';
import RECORD_FOUND_LBL from '@salesforce/label/c.RecordsFound';
import RECENTLY_VIEWED_RECORDS_LBL from '@salesforce/label/c.RecentlyViewedRecords';



const LABELS = {
    Search: SEARCH_LBL,
    NotRecordsFound: NOT_RECORDS_FOUND_LBL,
    RecordsFound: RECORD_FOUND_LBL,
    RecentlyViewedRecords: RECENTLY_VIEWED_RECORDS_LBL
};

export default class UiLookupInput extends NavigationMixin(LightningElement) {
    @api objectApiName;
    @api name = 'UiLookupInput';
    @api iconName;
    @api whereConditions;
    @api customLogic;
    @api fields;
    @api label;
    @api required = false;
    @api fieldName = 'Name';
    @api messageWhenValueMissing;
    @api searchTerm = undefined;
    @api placeholder = LABELS.Search + '...';
    @api limit = 10;
    @api clearOnSelect = false;

    @track _readOnly = false;
    @track _recordId;
    @track selectedName;
    @track _records;
    @track originalRecords;
    @track isValueSelected;
    @track blurTimeout;

    @api
    get records() {
        return this._records;
    }
    set records(value) {
        let result;
        if (value) {
            result = [];
            for (const val of value) {
                result.push({
                    Id: val.Id,
                    Name: SchemaUtils.getSObjectFieldValue(val, this.fieldName)
                });
            }
        }
        this.setAttribute('records', result);
        this._records = result;
    }

    @api
    get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this.setAttribute('recordId', value);
        this._recordId = value;
        if (!value) {
            this.selectedName = undefined;
            this.isValueSelected = false;
        } else {
            this.getRecord();
        }
    }

    @api
    get readOnly() {
        return this._readOnly;
    }
    set readOnly(value) {
        this.setAttribute('readOnly', value);
        this._readOnly = value;
    }

    recordsResultLabel = LABELS.NotRecordsFound;
    searchTerm;
    href;
    pillRemoved;
    elementClicked = false;
    onload = true;
    // css
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';

    renderedCallback() {
        if (!this.elementClicked) {
            if (this.pillRemoved) {
                this.checkRequired();
                this.pillRemoved = false;
            }
        }
        this.onload = false;
        this.elementClicked = false;
    }

    handleClick() {
        console.log(this.name + ' handleClick()');
        this.elementClicked = true;
        this.searchTerm = undefined;
        this.records = undefined;
        this._recordId = undefined;
        this.getRecentlyViewedRecords();
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    onBlur() {
        console.log(this.name + ' onBlur()');
        this.blurTimeout = setTimeout(() => { this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus' }, 300);
        this.checkRequired();
    }

    onSelect(event) {
        console.log(this.name + ' onSelect()');
        this._recordId = event.currentTarget.dataset.id;
        this.selectedName = event.currentTarget.dataset.name;
        let recordResult = {};
        for (let record of this.originalRecords) {
            if (record.Id === this._recordId) {
                recordResult = record;
                break;
            }
        }
        this.href = '/' + recordResult.Id;
        this.isValueSelected = true;
        this.checkRequired();
        const eventBuilder = EventManager.eventBuilder('select');
        eventBuilder.addValue('value', recordResult);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
        if (this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        if (this.clearOnSelect) {
            this.searchTerm = undefined;
            this.records = undefined;
            this.recordId = undefined;
            this.isValueSelected = false;
        }
    }

    handleRemovePill() {
        console.log(this.name + ' handleRemovePill()');
        this.searchTerm = undefined;
        this.isValueSelected = false;
        this._recordId = undefined;
        const eventBuilder = EventManager.eventBuilder('remove');
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
        this.pillRemoved = true;
    }

    handleClickPill(event) {
        event.stopPropagation();
        console.log(this.name + ' handleClickPill()');
        if (this._recordId) {
            NavigationService.goToRecordPage(this, this._recordId, true);
        }
    }

    onChange(event) {
        console.log(this.name + ' onChange()');
        this.searchTerm = event.target.value;
        if (this.searchTerm && this.searchTerm.length >= 3) {
            const queryBuilder = Database.queryBuilder(this.objectApiName, this.fields);
            queryBuilder.setWhereConditions(this.processWhere(this.whereConditions)).setCustomLogic(this.customLogic).setLimit(this.limit);
            Database.query(queryBuilder).then((records) => {
                this.error = undefined;
                this.records = records;
                this.originalRecords = records;
                if (this.records.length > 0)
                    this.recordsResultLabel = LABELS.RecordsFound;
                else
                    this.recordsResultLabel = LABELS.NotRecordsFound;
            }).catch((error) => {
                console.log(error);
                this.error = error;
                this.records = undefined;
                this.recordsResultLabel = LABELS.NotRecordsFound;
            });
        }
        this.checkRequired();
    }

    processWhere(whereConditions) {
        console.log(this.name + ' processWhere()');
        const resultWhere = [];
        let searchFound = false;
        for (const where of whereConditions) {
            const newWhere = {
                field: where.field,
                operator: where.operator,
                value: where.value
            }
            if (newWhere.value !== undefined && newWhere.value.indexOf('{search}') != -1) {
                newWhere.value = newWhere.value.split('{search}').join(this.searchTerm);
                searchFound = true;
            }
            resultWhere.push(newWhere);
        }
        if (!searchFound) {
            resultWhere.push({
                field: this.fieldName,
                operator: 'like',
                value: '%' + this.searchTerm + '%'
            });
            const whereNumberStr = '' + resultWhere.length;
            if (this.customLogic && !StrUtils.contains(this.customLogic, whereNumberStr)) {
                this.customLogic = '(' + this.customLogic + ') AND ' + resultWhere.length;
            }
        }
        return resultWhere;
    }

    checkRequired() {
        console.log(this.name + ' checkRequired()');
        if (this.required) {
            const input = this.template.querySelector('[data-id="input"]');
            if (!this.isValueSelected && !this.searchTerm)
                input.setCustomValidity(this.messageWhenValueMissing);
            else
                input.setCustomValidity('');
            input.reportValidity();
        }
    }

    getRecentlyViewedRecords() {
        console.log(this.name + ' getRecentlyViewedRecords()');
        const resultWhere = [
            {
                field: 'LastViewedDate',
                operator: '!=',
                value: null
            }
        ];
        for (const where of this.whereConditions) {
            const newWhere = {
                field: where.field,
                operator: where.operator,
                value: where.value
            }
            if (newWhere.value !== undefined && newWhere.value.indexOf('{search}') === -1)
                resultWhere.push(newWhere);
        }
        const params = {
            objectApiName: this.objectApiName,
            fields: this.fields,
            whereConditions: resultWhere,
            customLogic: undefined,
            groupBy: null,
            orderBy: {
                fields: ['LastViewedDate'],
                order: 'DESC'
            },
            queryLimit: 10,
        };
        const queryBuilder = Database.queryBuilder(this.objectApiName, this.fields);
        queryBuilder.setWhereConditions(resultWhere).createOrderBy(['LastViewedDate'], 'DESC');
        queryBuilder.setLimit(10);
        Database.query(queryBuilder).then((records) => {
            console.log(records);
            this.error = undefined;
            this.records = records;
            this.originalRecords = records;
            if (this.records.length > 0)
                this.recordsResultLabel = LABELS.RecentlyViewedRecords;
            else
                this.recordsResultLabel = LABELS.NotRecordsFound;
        }).catch((error) => {
            this.error = error;
            this.records = undefined;
            this.recordsResultLabel = LABELS.NotRecordsFound;
        });
    }

    getRecord() {
        console.log(this.name + ' getRecord()');
        const queryBuilder = Database.queryBuilder(this.objectApiName, this.fields);
        queryBuilder.addWhereCondition('Id', '=', this._recordId);
        Database.query(queryBuilder).then((records) => {
            const record = records[0];
            this._recordId = record.Id;
            this.selectedName = SchemaUtils.getSObjectFieldValue(record, this.fieldName);
            this.href = '/' + this._recordId;
            this.isValueSelected = true;
            const eventBuilder = EventManager.eventBuilder('select');
            eventBuilder.addValue('value', record);
            eventBuilder.setSource(this.name);
            EventManager.fire(this, eventBuilder.build());
            if (this.blurTimeout) {
                clearTimeout(this.blurTimeout);
            }
            this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        }).catch((error) => {
            this.error = error;
            this.records = undefined;
            this.recordsResultLabel = LABELS.NotRecordsFound;
        });
    }
}