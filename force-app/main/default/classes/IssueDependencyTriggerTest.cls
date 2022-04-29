
@isTest
public with sharing class IssueDependencyTriggerTest {
    
    private static acn__Issue__c mainIssue {
        get{
            if (mainIssue == null){
                mainIssue = [Select Id from acn__Issue__c where acn__Headline__c = 'Test Main Issue' ];
            }
            return mainIssue;
        }
        set;
    }

    private static acn__Issue__c dependantIssue {
        get{
            if (dependantIssue == null){
                dependantIssue = [Select Id from acn__Issue__c where acn__Headline__c = 'Test dependant Issue' ];
            }
            return dependantIssue;
        }
        set;
    }

    private static acn__Project__c project {
        get {
            if (project == null){
                project = [Select Id from acn__Project__c where name = 'Test Project'];
            }
            return project;
        }
        set;
    }

    private static Contact contact {
        get{
            if (contact == null){
                contact = [Select Id from Contact where LastName = 'Test Contact'];
            }
            return contact;
        }
        set;
    }

    @TestSetup
    public static void testSetup(){
        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        Contact contact = TestDataFactory.createContact('Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
        acn__Project__c project = TestDataFactory.createProject('Test Project', 'ABD', contact.Id);
        insert project;
        mainIssue = TestDataFactory.createIssue('Test Main Issue', contact.Id, project.Id);
        insert mainIssue;
        dependantIssue = TestDataFactory.createIssue('Test dependant Issue', contact.Id, project.Id);
        insert dependantIssue;
    }

    @isTest
    public static void testInsertIssueDependency (){
        acn__IssueDependency__c newIssueDependency = new acn__IssueDependency__c ();
        newIssueDependency.acn__MainIssue__c = mainIssue.Id;
        newIssueDependency.acn__DependantIssue__c = dependantIssue.Id;
        newIssueDependency.acn__Description__c = 'Test descroption';

        Test.startTest();
        insert newIssueDependency;
        Test.stopTest();

        acn__IssueDependency__c issueResult = [Select Id, acn__UniqueKey__c from acn__IssueDependency__c where Id = :newIssueDependency.Id];
        System.assertEquals(mainIssue.Id + '_' + dependantIssue.id, issueResult.acn__UniqueKey__c);
    }

    @isTest
    public static void testUpdateIssueDependency (){
        acn__IssueDependency__c newIssueDependency = new acn__IssueDependency__c ();
        newIssueDependency.acn__MainIssue__c = mainIssue.Id;
        newIssueDependency.acn__DependantIssue__c = dependantIssue.Id;
        newIssueDependency.acn__Description__c = 'Test descroption';

        acn__Issue__c mainIssue2 = TestDataFactory.createIssue('Test Main Issue2', contact.Id, project.Id);
        insert mainIssue2;

        Test.startTest();
        insert newIssueDependency;
        newIssueDependency.acn__MainIssue__c = mainIssue2.Id;
        update newIssueDependency;
        Test.stopTest();

        acn__IssueDependency__c issueResult = [Select Id, acn__UniqueKey__c from acn__IssueDependency__c where Id = :newIssueDependency.Id];
        System.assertEquals(mainIssue2.Id + '_' + dependantIssue.Id, issueResult.acn__UniqueKey__c);
    } 
    
}
