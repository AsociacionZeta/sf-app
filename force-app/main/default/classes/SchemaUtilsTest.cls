@isTest
public with sharing class SchemaUtilsTest {
    @isTest
    public static void getObjectFieldsNameMapTest() {
        Map<String, String> result = SchemaUtils.getObjectFieldsNameMap('Account');
    }

    @isTest
    public static void getSObjectTypeFromIdTest() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.BillingCountry = 'ES';
        insert acc;
        SObjectType result = SchemaUtils.getSObjectTypeFromId(acc.Id);
        system.assert(result == Account.SObjectType);
        result = SchemaUtils.getSObjectTypeFromId(String.valueOf(acc.Id));
        system.assert(result == Account.SObjectType);
        String result2 = SchemaUtils.getSObjectTypeFromIdLT(String.valueOf(acc.Id));
        system.assert(result2 == 'Account');
    }

    @isTest
    public static void getSObjectFieldTest() {
        Schema.SObjectField result = SchemaUtils.getSObjectField(Account.SObjectType, 'AccountNumber');
    }

    @isTest
    public static void getPicklistValuesTest() {
        List<String> result = SchemaUtils.getPicklistValues(Account.SObjectType, 'AccountSource');
        result = SchemaUtils.getPicklistValuesLT('Account', 'AccountSource');
    }

    @isTest
    public static void getPicklistValuesMapTest() {
        Map<String, String> result = SchemaUtils.getPicklistValuesMap(Account.SObjectType, 'AccountSource');
        List<Object> result2 = SchemaUtils.getPicklistValuesDataLT('Account', 'AccountSource');
    }

    @isTest
    public static void getDependentPicklistValuesMap() {
        Map<String, Map<String, String>> result = SchemaUtils.getDependentPicklistValuesMap(Account.SObjectType, 'AccountSource');
        result = SchemaUtils.getDependentPicklistValuesMapLT('Account', 'AccountSource');
    }

    @isTest
    public static void getKeyPrefixTest() {
        String result = SchemaUtils.getKeyPrefix(Account.SObjectType);
        result = SchemaUtils.getKeyPrefix('Account');
        result = SchemaUtils.getKeyPrefixLT('Account');
    }

    @isTest
    public static void describeSObjectLT() {
        SchemaUtils.SObjectDescribe result = SchemaUtils.describeSObjectLT('Account');
    }

}