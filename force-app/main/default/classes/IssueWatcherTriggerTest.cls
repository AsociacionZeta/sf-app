@istest
public with sharing class IssueWatcherTriggerTest{
    public static Contact Contact{ 
        get {
            if (contact == null){
                contact = [Select Id from Contact where LastName = 'Test Contact'];
            }
            return contact;
        }
        set; 
    }

    public static acn__Project__c project{ 
        get  {
            if (project == null){
                project = [Select Id from acn__Project__c where name = 'Test Project'];
            }
            return project;
        } 
        set; 
    }

    public static acn__Issue__c issue{
         get {
            if (issue == null){
                issue = [Select Id from acn__Issue__c where acn__Headline__c = 'Test Issue'];
            }
            return issue;
        }  
         set; 
    }

    
    @TestSetup
    public static void testSetup(){
        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        contact = TestDataFactory.createContact('Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
        project = TestDataFactory.createProject('Test Project', 'ABC', contact.Id);
        insert project;
        issue = TestDataFactory.createIssue('Test Issue', contact.Id, project.Id);
        insert issue;
    }

    @isTest
    public static void testInsertIssueWatcher(){
        acn__IssueWatcher__c newIssueWatcher = new acn__IssueWatcher__c();
        newIssueWatcher.acn__Contact__c = contact.Id;
        newIssueWatcher.acn__Issue__c = issue.Id;

        Test.startTest();
        insert newIssueWatcher;
        Test.stopTest();

        acn__IssueWatcher__c issueResult = [Select id, acn__UniqueKey__c from acn__IssueWatcher__c where Id = :newIssueWatcher.Id];

        System.assertEquals(issue.Id + '_' + contact.Id , issueResult.acn__UniqueKey__c);
    }

    @isTest
    public static void testUpdateIssueWatcher(){
        acn__IssueWatcher__c newIssueWatcher = new acn__IssueWatcher__c();
        newIssueWatcher.acn__Contact__c = contact.Id;
        newIssueWatcher.acn__Issue__c = issue.Id;

        //Contact contact2 = TestDataFactory.createContact('Test Contact2', account.Id, UserInfo.getUserId());
        //insert contact2;
        acn__Issue__c issue2 = TestDataFactory.createIssue('Test Issue2', contact.Id, project.Id);
        insert issue2;

        Test.startTest();
        insert newIssueWatcher;
        //newIssueWatcher.acn__Contact__c = contact2.Id;
        newIssueWatcher.acn__Issue__c = issue2.Id;
        update newIssueWatcher;
        Test.stopTest();

        acn__IssueWatcher__c issueResult = [Select id, acn__UniqueKey__c from acn__IssueWatcher__c where Id = :newIssueWatcher.Id];

        System.assertEquals(issue2.Id + '_' + contact.Id , issueResult.acn__UniqueKey__c);
    }


}