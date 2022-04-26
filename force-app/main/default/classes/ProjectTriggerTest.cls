@isTest
public with sharing class ProjectTriggerTest{
    private static Contact contact{
        get{
            if (contact == null){
                contact = [Select Id
                           from Contact
                           where LastName = 'Test Contact'];
            }
            return contact;
        }

        set;
    }

    @TestSetup
    public static void testSetUp(){

        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        Contact contact = TestDataFactory.createContact('Test Contact', account.Id, userInfo.getUserId());
        insert contact;
    }

    @isTest
    public static void testInsertProject(){
        acn__Project__c newProject = new acn__Project__c();
        newProject.acn__Code__c = 'testcode';
        newProject.acn__Description__c = 'Test descrption';
        newProject.acn__Manager__c = Contact.Id;
        newProject.acn__StartDate__c = System.today();
        newProject.acn__IssuesCount__c = 1;

        Test.startTest();
        insert newProject;
        Test.stopTest();

        acn__Project__c projectResult = [Select Id, acn__Code__c from acn__Project__c where Id = :newProject.Id];

        System.assertEquals('TESTCODE', projectResult.acn__Code__c);
    }

    @isTest
    public static void testUpdateProject(){
        acn__Project__c newProject = new acn__Project__c();
        newProject.acn__Code__c = 'testcode';
        newProject.acn__Description__c = 'Test descrption';
        newProject.acn__Manager__c = Contact.Id;
        newProject.acn__StartDate__c = System.today();
        newProject.acn__IssuesCount__c = 1;

        Test.startTest();
        insert newProject;
        newProject.acn__Code__c = 'newtestcode';
        update newProject;
        Test.stopTest();

        acn__Project__c projectResult = [Select Id, acn__Code__c from acn__Project__c where Id = :newProject.Id];

        System.assertEquals('NEWTESTCODE', projectResult.acn__Code__c);
    }

}