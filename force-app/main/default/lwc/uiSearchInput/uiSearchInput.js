import { LightningElement, api, track, wire } from 'lwc';
import EventManager from 'c/classEventManager';
import CoreUtils from 'c/classCoreUtils';

// LABELS IMPORT
import NO_VALUES_TO_SHOW_LBL from '@salesforce/label/c.NoValuesToShow';
import SELECT_ALL_LBL from '@salesforce/label/c.SelectAll';
import SEARCH_LBL from '@salesforce/label/c.Search';
import VALUES_LBL from '@salesforce/label/c.Values';

const LABELS = {
    NoValues: NO_VALUES_TO_SHOW_LBL,
    SelectAll: SELECT_ALL_LBL,
    Search: SEARCH_LBL,
    Values: VALUES_LBL,
};

export default class UiSearchInput extends LightningElement {

    @api name = 'UiSearchInput';

    @api label;
    @api required = false;
    @api messageWhenValueMissing;
    @api placeholder = LABELS.Search + '...';
    @api limit;
    @api readOnly = false;
    @api clearOnSelect = false;
    @api allowSelectAll = false;
    @api searchTerm = undefined;
    @api valuesText = LABELS.Values;

    @track _iconName;
    @track _values = [];
    @track _value = undefined;
    @track selectedName;
    @track isValueSelected;
    @track blurTimeout;
    @track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    @track inputClass = '';
    @track valuesToShow = [];
    @track noValues = false;
    @track selectedIconName;
    @track selectedIconText;

    pillRemoved;
    elementClicked = false;
    onload = true;
    labels = LABELS;

    @api
    get value() {
        return this._value;
    }
    set value(value) {
        console.log(this.name + ' set Value(' + value + ')');
        this.setAttribute('value', value);
        this._value = value;
        if (!value) {
            this.selectedName = undefined;
            this.isValueSelected = false;
        } else {
            this.getSelectedValue();
        }
    }

    @api
    get values() {
        return this._values;
    }
    set values(values) {
        this._values = CoreUtils.clone(values);
        this.setAttribute('values', this._values);
        this.getSelectedValue();
        this.fixIconOnValues();
    }

    @api
    get iconName() {
        return this._iconName;
    }
    set iconName(iconName) {
        this._iconName = iconName;
        this.setAttribute('iconName', this._iconName);
        this.fixIconOnValues();
    }

    fixIconOnValues() {
        console.log(this.name + ' fixIconOnValues()');
        if (this._values) {
            for (const val of this._values) {
                if (!val.iconName) {
                    val.iconName = this._iconName;
                }
            }
        }
    }

    renderedCallback() {
        console.log(this.name + ' renderedCallback()');
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
        this.getValuesToShow();
        this.inputClass = 'slds-has-focus';
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
    }

    getValuesToShow() {
        console.log(this.name + ' getValuesToShow()');
        this.valuesToShow = [];
        if (this._values) {
            for (const val of this._values) {
                if (this.limit && this.valuesToShow.length === this.limit)
                    break;
                if (this.searchTerm) {
                    if (val.label && val.label.toLowerCase().indexOf(this.searchTerm.toLowerCase()) !== -1)
                        this.valuesToShow.push(val);
                } else {
                    this.valuesToShow.push(val);
                }
            }
        }
        this.noValues = this.valuesToShow.length == 0;
    }

    getSelectedValue() {
        console.log(this.name + ' getSelectedValue()');
        if(!this._value)
            return;
        let value = {};
        if (this._values && this._values.length > 0) {
            for (let val of this._values) {
                if (val.value === this._value) {
                    value = val;
                    break;
                }
            }
        } else {
            value.value = this.value;
        }
        this.selectedName = value.label;
        this.isValueSelected = true;
        this.selectedIconName = value.iconName;
        this.selectedIconText = value.altText;
        this.checkRequired();
        const eventBuilder = EventManager.eventBuilder('select');
        eventBuilder.addValue('value', value.value);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
        if (this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
    }

    onBlur() {
        console.log(this.name + ' onBlur()');
        this.blurTimeout = setTimeout(() => { this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus' }, 300);
        this.checkRequired();
    }

    onSelect(event) {
        console.log(this.name + ' onSelect()');
        this._value = event.currentTarget.dataset.id;
        this.selectedName = event.currentTarget.dataset.name;
        let value = {};
        for (let val of this._values) {
            if (val.value === this._value) {
                value = val;
                break;
            }
        }
        this.selectedName = value.label;
        this.isValueSelected = true;
        this.checkRequired();
        const eventBuilder = EventManager.eventBuilder('select');
        eventBuilder.addValue('value', value.value);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
        if (this.blurTimeout) {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
        if (this.clearOnSelect) {
            this.searchTerm = undefined;
            this.valuesToShow = [];
            this._value = undefined;
            this.isValueSelected = false;
        }
    }

    handleRemovePill() {
        console.log(this.name + ' handleRemovePill()');
        this.searchTerm = undefined;
        this.isValueSelected = false;
        this.value = undefined;
        const eventBuilder = EventManager.eventBuilder('remove');
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
        this.pillRemoved = true;
    }

    checkRequired() {
        if (this.required) {
            console.log(this.name + ' checkRequired()');
            const input = this.template.querySelector('[data-id="input"]');
            if (!this.isValueSelected && !this.searchTerm)
                input.setCustomValidity(this.messageWhenValueMissing);
            else
                input.setCustomValidity('');
            input.reportValidity();
        }
    }

    onChange(event) {
        console.log(this.name + ' onChange()');
        this.searchTerm = event.target.value;
        if (this.searchTerm && this.searchTerm.length > 0) {
            this.getValuesToShow();
        }
        this.checkRequired();
    }

    onSelectAll() {
        console.log(this.name + ' onSelectAll()');
        const values = [];
        for (const value of this.valuesToShow) {
            values.push(value.value);
        }
        const eventBuilder = EventManager.eventBuilder('selectall');
        eventBuilder.addValue('values', values);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
    }

    handleClickPill(event) {
        console.log(this.name + ' handleClickPill()');
        const eventBuilder = EventManager.eventBuilder('clickpill');
        eventBuilder.addValue('value', this._value);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
    }

}