import { LightningElement } from 'lwc';
import getCurrentUser from '@salesforce/apex/UserData.getCurrentUser';
import getCurrentContact from '@salesforce/apex/UserData.getCurrentUser';
import StrUtils from 'c/classStrUtils';

/**
 * Class to handle all about the logged user or work with users
 */
export default class UserInfo extends LightningElement {

    static getCurrentUser(){
        return getCurrentUser();
    }

    static getCurrentContact(){
        return getCurrentContact();
    }

    /**
     * Method to check if an user is an Admin user or not
     * @param {Object} user 
     * @returns True if the user is Admin, false in otherwise
     */
    static isAdmin(user) {
        if (user) {
            return StrUtils.containsIgnoreCase(user.Profile.Name, 'admin') && (StrUtils.containsIgnoreCase(user.Profile.Name, 'sys') || StrUtils.containsIgnoreCase(user.Profile.Name, 'sis'))
        }
        return false;
    }

}