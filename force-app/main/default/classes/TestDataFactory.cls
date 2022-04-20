@isTest
public with sharing class TestDataFactory {

    public static Account createAccount(String name) {
        Account newAccount = new Account();
        newAccount.Name = name;
        newAccount.BillingCountry = 'ES';
        return newAccount;
    }

    public static Contact createContact(String lastName, Id accountId, Id userId) {
        Contact newContact = new Contact();
        newContact.AccountId = accountId;
        newContact.LastName = lastName;
        newContact.acn__User__c = userId;
        return newContact;
    }

    public static acn__Project__c createProject(String name, String code, Id managerId){
        acn__Project__c newProject = new acn__Project__c();
        newProject.Name = name;
        newProject.acn__Code__c = code;
        newProject.acn__Manager__c = managerId;
        newProject.acn__Description__c = 'Test Description';
        newProject.acn__StartDate__c = system.today();
        newProject.acn__IssuesCount__c = 0;
        return newProject;
    }

}