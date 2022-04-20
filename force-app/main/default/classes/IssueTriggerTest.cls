@isTest
public with sharing class IssueTriggerTest {
    
    private static Contact contact {
        get {
            if(contact == null){
                contact = [Select Id from Contact where LastName = 'Test Contact'];
            }
            return contact;
        }
        set;
    }

    private static acn__Project__c project {
        get {
            if(project == null){
                project = [Select Id from acn__Project__c where acn__Code__c = 'TEST'];
            }
            return project;
        }
        set;
    }

    private static acn__Project__c project2 {
        get {
            if(project2 == null){
                project2 = [Select Id from acn__Project__c where acn__Code__c = 'TEST2'];
            }
            return project2;
        }
        set;
    }

    @TestSetup
    public static void testSetup(){
        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        contact = TestDataFactory.createContact('Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
        project = TestDataFactory.createProject('Test Project', 'TEST', contact.Id);
        insert project;
        project2 = TestDataFactory.createProject('Test Project 2', 'TEST2', contact.Id);
        insert project2;
    }

    @isTest
    public static void testInsertIssue(){
        acn__Issue__c newIssue = new acn__Issue__c();
        newIssue.acn__AssignedTo__c = contact.Id;
        newIssue.acn__OpenedBy__c = contact.Id;
        newIssue.acn__Headline__c = 'Test Headline';
        newIssue.acn__EstimatedTime__c = 50;
        newIssue.acn__StartDate__c = System.today().addDays(1);
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__Project__c = project.Id;
        newIssue.acn__Description__c = 'Test Issue';
        Test.startTest();
        insert newIssue;
        Test.stopTest();

        acn__Issue__c issueResult = [Select Id, Name from acn__Issue__c where Id = :newIssue.Id];
        acn__Project__c projectResult = [Select Id, acn__IssuesCount__c from acn__Project__c where Id = :project.Id];

        system.assertEquals('TEST-00001', issueResult.Name);
        system.assertEquals(1, projectResult.acn__IssuesCount__c);
    }

    @isTest
    public static void testUpdateIssue(){
        acn__Issue__c newIssue = new acn__Issue__c();
        newIssue.acn__AssignedTo__c = contact.Id;
        newIssue.acn__OpenedBy__c = contact.Id;
        newIssue.acn__Headline__c = 'Test Headline';
        newIssue.acn__EstimatedTime__c = 50;
        newIssue.acn__StartDate__c = System.today().addDays(1);
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__Project__c = project.Id;
        newIssue.acn__Description__c = 'Test Issue';
        Test.startTest();
        insert newIssue;
        newIssue.acn__Project__c = project2.Id;
        update newIssue;
        Test.stopTest();

        acn__Issue__c issueResult = [Select Id, Name from acn__Issue__c where Id = :newIssue.Id];
        acn__Project__c projectResult = [Select Id, acn__IssuesCount__c from acn__Project__c where Id = :project.Id];
        acn__Project__c project2Result = [Select Id, acn__IssuesCount__c from acn__Project__c where Id = :project2.Id];

        system.assertEquals('TEST2-00001', issueResult.Name);
        system.assertEquals(0, projectResult.acn__IssuesCount__c);
        system.assertEquals(1, project2Result.acn__IssuesCount__c);
    }


}
