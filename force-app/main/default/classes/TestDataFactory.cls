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
        newContact.Email = 'email@test.com';
        return newContact;
    }

    public static Contact createContact(String firstName, String lastName, Id accountId, Id userId) {
        Contact newContact = createContact(lastName, accountId, userId);
        newContact.FirstName = firstName;
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

    public static acn__IssueStatus__c createIssueStatus(String name, Id projectId, String type, Boolean initial){
        acn__IssueStatus__c newIssueStatus = new acn__IssueStatus__c ();
        newIssueStatus.Name = name;
        newIssueStatus.acn__Active__c = true;
        newIssueStatus.acn__Initial__c = initial;
        newIssueStatus.acn__Project__c = projectId;
        newIssueStatus.acn__Type__c = type;
        return newIssueStatus;
    }

    public static acn__IssueStatusOrder__c createIssueStatusOrder(Id statusId, Id changeToId, Id assignToId){
        acn__IssueStatusOrder__c newIssueStatusOrder = new acn__IssueStatusOrder__c ();
        newIssueStatusOrder.acn__Status__c = statusId;
        newIssueStatusOrder.acn__ChangeTo__c = changeToId;
        newIssueStatusOrder.acn__AssignTo__c = assignToId;
        return newIssueStatusOrder;
    }
    

}