@isTest
public with sharing class ProjectCollaboratorTriggerTest {

    private static Contact contact {
        get{
            if (contact == null){
                contact = [Select Id from Contact where LastName = 'Test Contact'];
            }
            return contact;
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

    @TestSetup
    public static void testSetUp(){

        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        contact = TestDataFactory.createContact('Test Contact', account.Id, userInfo.getUserId());
        insert contact;
        project = TestDataFactory.createProject('Test Project', 'ABC', contact.Id);
        insert project;

    }

    @isTest
    public static void testInsertProjectCollaborator(){

        acn__ProjectCollaborator__c newProjectCollaborator = new acn__ProjectCollaborator__c();
        newProjectCollaborator.acn__Contact__c = contact.Id;
        newProjectCollaborator.acn__Project__c = project.Id;
        newProjectCollaborator.acn__Role__c = 'Desarrollador';

        Test.startTest();
        insert newProjectCollaborator;
        Test.stopTest();

        acn__ProjectCollaborator__c projectResult = [Select Id, acn__Unique_Key__c from acn__ProjectCollaborator__c where Id = :newProjectCollaborator.Id];

        System.assertEquals(project.Id + '-' + contact.Id, projectResult.acn__Unique_Key__c);
    }

    @isTest
    public static void testUpdateProjectCollaborator(){
        acn__ProjectCollaborator__c newProjectCollaborator = new acn__ProjectCollaborator__c();
        newProjectCollaborator.acn__Contact__c = contact.Id;
        newProjectCollaborator.acn__Project__c = project.Id;
        newProjectCollaborator.acn__Role__c = 'Desarrollador';

        acn__Project__c  project2 = TestDataFactory.createProject('Test Project2', 'ABCD', contact.Id);
        insert project2;

        Test.startTest();
        insert newProjectCollaborator;
        newProjectCollaborator.acn__Project__c = project2.Id;
        update newProjectCollaborator;
        Test.stopTest();

        acn__ProjectCollaborator__c projectResult = [Select Id, acn__Unique_Key__c from acn__ProjectCollaborator__c where Id = :newProjectCollaborator.Id];

        System.assertEquals(project2.Id + '-' + contact.Id , projectResult.acn__Unique_Key__c);
    }
   
}
