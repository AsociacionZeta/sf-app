public with sharing class UserData {

    private static final List<String> USER_FIELDS = new List<String>{'Id', 'Name', 'FirstName', 'LastName', 'Email', 'ProfileId', 'Profile.Name', 'UserRoleId', 'UserRole.Name'}; 
    private static final List<String> CONTACT_FIELDS = new List<String>{'Id', 'Name', 'FirstName', 'LastName', 'Email', 'acn__User__c'}; 

    public static Id contactId { get; set; }

    public static User currentUser {
        get {
            if (currentUser == null) {
                if (contactId != null) {
                    currentUser = queryUser(currentContact.acn__User__c);
                } else {
                    currentUser = queryUser(UserInfo.getUserId());
                }
            }
            return currentUser;
        }

        set;
    }

    public static Contact currentContact {
        get {
            if (currentContact == null) {
                if(contactId != null){
                    currentContact = queryContact(contactId);
                } else {
                    currentContact = queryContactFromUser(currentUser.Id);
                }
            }
            return currentContact;
        }

        set;
    }

    @AuraEnabled
    public static User getCurrentUser(){
        return currentUser;
    }

    @AuraEnabled
    public static Contact getCurrentContact(){
        return currentContact;
    }

    public static Boolean isAdmin(){
        if(currentUser != null && currentUser.Profile.Name.containsIgnoreCase('admin') && (currentUser.Profile.Name.containsIgnoreCase('sis') || currentUser.Profile.Name.containsIgnoreCase('sys'))){
            return true;
        }
        return false;
    }

    public static String getDefaultCurrency(){
        return UserInfo.getDefaultCurrency();
    }

    public static String getFirstName(){
        return currentContact.FirstName;
    }

    public static String getLanguage(){
        return UserInfo.getLanguage();
    }

    public static String getLastName(){
        return currentContact.LastName;
    }

    public static String getLocale(){
        return UserInfo.getLocale();
    }

    public static String getName(){
        return currentContact.Name;
    }

    public static String getOrganizationId(){
        return UserInfo.getOrganizationId();
    }

    public static String getOrganizationName(){
        return UserInfo.getOrganizationName();
    }

    public static String getProfileId(){
        return UserInfo.getProfileId();
    }

    public static String getSessionId(){
        return UserInfo.getSessionId();
    }

    public static TimeZone getTimeZone(){
        return UserInfo.getTimeZone();
    }

    public static String getUiTheme(){
        return UserInfo.getUiTheme();
    }

    public static String getUiThemeDisplayed(){
        return UserInfo.getUiThemeDisplayed();
    }

    public static String getUserEmail(){
        return currentContact.Email;
    }

    public static String getUserId(){
        return UserInfo.getUserId();
    }

    public static String getContactUserId(){
        return currentContact.Id;
    }

    private static User queryUser(String userId){
        String query = 'Select ' + String.join(USER_FIELDS, ',') + ' from User where Id = :userId';
        List<User> users = Database.query(query);
        return users[0];
    }

    private static Contact queryContact(String contactId){
        String query = 'Select ' + String.join(CONTACT_FIELDS, ',') + ' from Contact where Id = :contactId';
        List<Contact> contacts = Database.query(query);
        return contacts[0];
    }

    private static Contact queryContactFromUser(String userId){
        String query = 'Select ' + String.join(CONTACT_FIELDS, ',') + ' from Contact where acn__User__c = :userId';
        List<Contact> contacts = Database.query(query);
        return contacts[0];
    }

}