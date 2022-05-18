@isTest
public with sharing class SprintTriggerTest{
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

    private static acn__Project__c project{
        get{
            if (project == null){
                project = [Select Id
                           from acn__Project__c
                           where name = 'Test Project'];
            }
            return project;
        }

        set;
    }

    @TestSetup
    public static void testSetup(){

        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        Contact contact = TestDataFactory.createContact('Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
        acn__Project__c project = TestDataFactory.createProject('Test Project', 'TEST', contact.Id);
        insert project;
    }

    @istest
    public static void testUpdateSprint(){

        acn__Sprint__c newSprint = new acn__Sprint__c();
        newSprint.acn__Comment__c = 'Test Coment';
        newSprint.acn__Project__c = project.Id;
        newSprint.acn__StartDate__c = System.today();
        newSprint.acn__Status__c = 'Active';
        newSprint.acn__Version__c = 'Test Version';

        Test.startTest();
        insert newSprint;
        newSprint.acn__Comment__c = 'Test New Coment';
        update newSprint;
        Test.stopTest();

        acn__Sprint__c sprintResult = [Select Id, acn__Comment__c from acn__Sprint__c where Id = :newSprint.id];

        System.assertEquals('Test New Coment', newSprint.acn__Comment__c);

    }

    @isTest
    public static void testValidationSprintStatusInsert(){

        acn__Sprint__c newSprint = new acn__Sprint__c();
        newSprint.acn__Comment__c = 'TestComent';
        newSprint.acn__Project__c = project.Id;
        newSprint.acn__StartDate__c = System.today();
        newSprint.acn__Status__c = 'Active';
        newSprint.acn__Version__c = 'Test Version';

        acn__Sprint__c newSprint2 = new acn__Sprint__c();
        newSprint2.acn__Comment__c = 'TestComent';
        newSprint2.acn__Project__c = project.Id;
        newSprint2.acn__StartDate__c = System.today();
        newSprint2.acn__Status__c = 'Active';
        newSprint2.acn__Version__c = 'Test Version';

        Test.startTest();
        //con el try catch testeamos que salta el error que estamos testeando y no otro (en este caso que no haya dos sprint activos para el mismo proyecto)
        try{
            insert newSprint;
            insert newSprint2;
            System.assert(false, 'Esta linea no debería ejecutarse');
        } catch (Exception e){
            System.assert(e.getMessage().contains(Label.DuplicatedActiveSprintError), e.getMessage());
        }
        Test.stopTest();
    }


    @isTest
    public static void testValidationSprintStatusUpdate(){
        acn__Sprint__c newSprint = new acn__Sprint__c();
        newSprint.acn__Comment__c = 'TestComent';
        newSprint.acn__Project__c = project.Id;
        newSprint.acn__StartDate__c = System.today();
        newSprint.acn__Status__c = 'Active';
        newSprint.acn__Version__c = 'Test Version';

        acn__Sprint__c newSprint2 = new acn__Sprint__c();
        newSprint2.acn__Comment__c = 'TestComent';
        newSprint2.acn__Project__c = project.Id;
        newSprint2.acn__StartDate__c = System.today();
        newSprint2.acn__Status__c = 'Opened';
        newSprint2.acn__Version__c = 'Test Version';

        Test.startTest();
        //con el try catch testeamos que salta el error que estamos testeando y no otro (en este caso que no haya dos sprint activos para el mismo proyecto)
        try{
            insert newSprint;
            insert newSprint2;
            newSprint2.acn__Status__c = 'Active';
            update newSprint2;
            System.assert(false, 'Esta linea no debería ejecutarse');
        } catch (Exception e){
            System.assert(e.getMessage().contains(Label.DuplicatedActiveSprintError), e.getMessage());
        }
        Test.stopTest();
    }

}