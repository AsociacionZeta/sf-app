import { LightningElement, api, track } from 'lwc';
import EventManager from 'c/classEventManager';
import CoreUtils from 'c/classCoreUtils';

export default class UiQuickActionFooter extends LightningElement {
    @api name = 'UiQuickActionFooter';
    @api
    get buttons() {
        return this._buttons;
    }
    set buttons(buttons) {
        if (buttons)
            this._buttons = CoreUtils.clone(buttons);
    }
    @api
    get disabled() {
        return this._buttons;
    }
    set disabled(disabled) {
        this._disabled = disabled;
        if (this._buttons) {
            for (const button of this._buttons) {
                button.disabled = this._disabled;
            }
        }
    }

    @track _buttons;
    @track _disabled;

    
    connectedCallback() {
        console.log(this.name + ' connectedCallback()');
        if (this._buttons && this._disabled !== undefined) {
            for (const button of this._buttons) {
                button.disabled = this._disabled;
            }
        }
    }

    @api
    disableButton(buttonName) {
        if (this._buttons) {
            for (const button of this._buttons) {
                if (button.name === buttonName) {
                    button.disabled = true;
                }
            }
        }
    }

    @api
    enableButton(buttonName) {
        if (this._buttons) {
            for (const button of this._buttons) {
                if (button.name === buttonName) {
                    button.disabled = false;
                }
            }
        }
    }

    handleClick(event) {
        console.log(this.name + ' handleClick()');
        const source = EventManager.getSource(event);
        const detail = EventManager.getEventDetail(event);
        const eventBuilder = EventManager.eventBuilder('buttonclick');
        eventBuilder.addValue('button', source);
        eventBuilder.setSource(this.name);
        EventManager.fire(this, eventBuilder.build());
    }
}