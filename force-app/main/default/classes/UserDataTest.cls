@isTest
public with sharing class UserDataTest {

    private static Contact contact{
        get{
            if (contact == null){
                contact = [Select Id, Name, FirstName, LastName, Email, acn__User__c
                           from Contact
                           where LastName = 'Test Contact'];
            }
            return contact;
        }

        set;
    }

    @TestSetup
    public static void testSetup(){
        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        contact = TestDataFactory.createContact('Test', 'Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
    }

    @isTest
    public static void getCurrentUserTest(){
        UserData.currentUser = null;
        User userResult = UserData.getCurrentUser();
        system.assertEquals(userResult.Id, UserInfo.getUserId());
        UserData.currentUser = null;
        UserData.contactId = contact.Id;
        userResult = UserData.getCurrentUser();
        system.assertEquals(userResult.Id, UserInfo.getUserId());
    }

    @isTest
    public static void getCurrentContactTest(){
        UserData.currentContact = null;
        Contact contactResult = UserData.getCurrentContact();
        system.assertEquals(contactResult.Id, contact.Id);
        UserData.currentContact = null;
        UserData.contactId = contact.Id;
        contactResult = UserData.getCurrentContact();
        system.assertEquals(contactResult.Id, contact.Id);
    }

    @isTest
    public static void isAdminTest(){
        system.assert(UserData.isAdmin());
    }

    @isTest
    public static void getDefaultCurrencyTest(){
        system.assertEquals(UserData.getDefaultCurrency(), UserInfo.getDefaultCurrency());
    }

    @isTest
    public static void getFirstNameTest(){
        system.assertEquals(UserData.getFirstName(), contact.FirstName);
    }

    @isTest
    public static void getLanguageTest(){
        system.assertEquals(UserData.getLanguage(), UserInfo.getLanguage());
    }

    @isTest
    public static void getLastNameTest(){
        system.assertEquals(UserData.getLastName(), contact.LastName);
    }

    @isTest
    public static void getLocaleTest(){
        system.assertEquals(UserData.getLocale(), UserInfo.getLocale());
    }

    @isTest
    public static void getNameTest(){
        system.assertEquals(UserData.getName(), contact.Name);
    }

    @isTest
    public static void getOrganizationIdTest(){
        system.assertEquals(UserData.getOrganizationId(), UserInfo.getOrganizationId());
    }

    @isTest
    public static void getOrganizationNameTest(){
        system.assertEquals(UserData.getOrganizationName(), UserInfo.getOrganizationName());
    }

    @isTest
    public static void getProfileIdTest(){
        system.assertEquals(UserData.getProfileId(), UserInfo.getProfileId());
    }

    @isTest
    public static void getSessionIdTest(){
        system.assertEquals(UserData.getSessionId(), UserInfo.getSessionId());
    }

    @isTest
    public static void getTimeZoneTest(){
        system.assertEquals(UserData.getTimeZone().toString(), UserInfo.getTimeZone().toString());
    }

    @isTest
    public static void getUiThemeTest(){
        system.assertEquals(UserData.getUiTheme(), UserInfo.getUiTheme());
    }

    @isTest
    public static void getUiThemeDisplayedTest(){
        system.assertEquals(UserData.getUiThemeDisplayed(), UserInfo.getUiThemeDisplayed());
    }

    @isTest
    public static void getUserEmailTest(){
        system.assertEquals(UserData.getUserEmail(), contact.Email);
    }

    @isTest
    public static void getUserIdTest(){
        system.assertEquals(UserData.getUserId(), UserInfo.getUserId());
    }

    @isTest
    public static void getContactUserIdTest(){
        system.assertEquals(UserData.getContactUserId(), contact.Id);
    }
}
