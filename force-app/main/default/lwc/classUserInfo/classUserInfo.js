import { LightningElement } from 'lwc';
import Database from 'c/classDatabase';
import StrUtils from 'c/classStrUtils';

// Logged user ID
import USER_ID_VALUE from '@salesforce/user/Id';

// User Fields
import USER_OBJ from '@salesforce/schema/User';

const USER_FIELDS = [
    'Id',
    'Name',
    'Profile.Name',
    'UserRoleId',
    'UserRole.Name',
    'Email',
    'CommunityNickname'
];

/**
 * Class to handle all about the logged user or work with users
 */
export default class UserInfo extends LightningElement {

    /**
     * Method to get data from logged user
     * @returns {Promise<User> | undefined} Returns a promise with user record
     */
    static getUserInfo() {
        return new Promise((resolve, reject) => {
            const queryBuilder = Database.queryBuilder(USER_OBJ.objectApiName, USER_FIELDS);
            queryBuilder.addWhereCondition('Id', '=', USER_ID_VALUE);
            Database.query(queryBuilder, true).then((records) => {
                if(records && records.length > 0){
                    resolve(records[0])
                } else {
                    resolve();
                }
            }).catch((error) => {
                reject(error);
            });
        });
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