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

    public static acn__Issue__c createIssue(String name, Id contactId, Id projectId ){
        acn__Issue__c newIssue = new acn__Issue__c ();
        newIssue.acn__Headline__c = name;
        newIssue.acn__AssignedTo__c = contactId;
        newIssue.acn__Project__c = projectId;
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__StartDate__c = system.today();
        newIssue.acn__EstimatedTime__c = 10;
        newIssue.acn__OpenedBy__c = contactId;
        newIssue.acn__Description__c = 'Test Description';
        return newIssue;
    }

    public static acn__ProjectCollaborator__c createProjectCollaborator(Id contactId, Id projectId){
        acn__ProjectCollaborator__c newProjectColaborator = new acn__ProjectCollaborator__c();
        newProjectColaborator.acn__Contact__c = contactId;
        newProjectColaborator.acn__Project__c = projectId;
        newProjectColaborator.acn__Role__c = 'Desarrollador';
        return newProjectColaborator;
    }
    

}