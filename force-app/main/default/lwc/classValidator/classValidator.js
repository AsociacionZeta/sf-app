import { LightningElement } from 'lwc';
import CoreUtils from 'c/classCoreUtils';

const DURATION_REGEX = /(?=\d+[YMWDhm])(( ?\d+Y)?(?!\d))?(( ?\d+M)?(?!\d))?(( ?\d+W)?(?!\d))?(( ?\d+D)?(?!\d))?(( ?\d+h)?(?!\d))?(( ?\d+m)?(?!\d))/;
const POSITIVE_NUMBERS_REGEX = /^\d+$/;

export default class Validator extends LightningElement {

    static isDuration(duration){
        if(CoreUtils.isString(duration)){
            return DURATION_REGEX.test(duration) || POSITIVE_NUMBERS_REGEX.test(duration);
        }
        return false;
    }

}