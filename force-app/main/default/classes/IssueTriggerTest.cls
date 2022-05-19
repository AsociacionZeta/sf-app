@isTest
public with sharing class IssueTriggerTest {

    private static Account account {
        get {
            if(account == null){
                account = [Select Id from account where name = 'Test Account'];
            }
            return account;
        }
        set;
    }

    
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
        account = TestDataFactory.createAccount('Test Account');
        insert account;
        contact = TestDataFactory.createContact('Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
        project = TestDataFactory.createProject('Test Project', 'TEST', contact.Id);
        insert project;
        project2 = TestDataFactory.createProject('Test Project 2', 'TEST2', contact.Id);
        insert project2;
        acn__ProjectCollaborator__c projectCollaborator = TestDataFactory.createProjectCollaborator(contact.Id, project.Id);
        insert projectCollaborator;
        acn__ProjectCollaborator__c projectCollaborator2 = TestDataFactory.createProjectCollaborator(contact.Id, project2.Id);
        insert projectCollaborator2;
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

    @isTest
    public static void testValidateIssueAssignmentOnInsert(){

        Contact contact2 = TestDataFactory.createContact('Test Contact 2', account.Id, UserInfo.getUserId());
        insert contact2;

        acn__Issue__c newIssue = new acn__Issue__c();
        newIssue.acn__AssignedTo__c = contact2.Id;
        newIssue.acn__OpenedBy__c = contact2.Id;
        newIssue.acn__Headline__c = 'Test Headline';
        newIssue.acn__EstimatedTime__c = 50;
        newIssue.acn__StartDate__c = System.today().addDays(1);
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__Project__c = project.Id;
        newIssue.acn__Description__c = 'Test Issue';

        Test.startTest();
        try {
            insert newIssue; 
            System.assert(false, 'Esta linea no debería ejecutarse');
        } catch (Exception e) {
            System.assert(e.getMessage().contains(Label.IssueContactAssignError), e.getMessage());
        }       
        Test.stopTest();        
    }

     @isTest
    public static void testValidateIssueAssignmentOnUpdate(){

        acn__Issue__c newIssue = new acn__Issue__c();
        newIssue.acn__AssignedTo__c = contact.Id;
        newIssue.acn__OpenedBy__c = contact.Id;
        newIssue.acn__Headline__c = 'Test Headline';
        newIssue.acn__EstimatedTime__c = 50;
        newIssue.acn__StartDate__c = System.today().addDays(1);
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__Project__c = project.Id;
        newIssue.acn__Description__c = 'Test Issue';

        Contact contact2 = TestDataFactory.createContact('Test Contact 2', account.Id, UserInfo.getUserId());
        insert contact2;

        Test.startTest();
        try {
            insert newIssue; 
            newIssue.acn__Assignedto__c = contact2.Id; //Contact2 no pertenece al proyecto y por tanto de deberia actualizarse
            update newIssue; // debe saltar al catch porque no puede actualizar el campo (el contacto 2 no es valido)
            System.assert(false, 'Esta linea no debería ejecutarse'); // si llega a esta linea es porque ha actualizado y al estar a "false" el test peta.
        } catch (Exception e) {
            System.assert(e.getMessage().contains(Label.IssueContactAssignError), e.getMessage()); //El aser tiene una condición (contener el mensaje que queremos) Si no es ese mensaje es porque es otro error y saltara el que corresponda.
        }       
        Test.stopTest();
    }

    @isTest
    public static void testValidateIssueOpenedByOnInsert(){

        Contact contact2 = TestDataFactory.createContact('Test Contact 2', account.Id, UserInfo.getUserId());
        insert contact2;

        acn__Issue__c newIssue = new acn__Issue__c();
        newIssue.acn__AssignedTo__c = contact.Id;
        newIssue.acn__OpenedBy__c = contact2.Id;
        newIssue.acn__Headline__c = 'Test Headline';
        newIssue.acn__EstimatedTime__c = 50;
        newIssue.acn__StartDate__c = System.today().addDays(1);
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__Project__c = project.Id;
        newIssue.acn__Description__c = 'Test Issue';

        Test.startTest();
        try {
            insert newIssue; 
            System.assert(false, 'Esta linea no debería ejecutarse');
        } catch (Exception e) {
            System.assert(e.getMessage().contains(Label.IssueOpenedByError), e.getMessage());
        }       
        Test.stopTest();        
    }

    @isTest
    public static void testValidateIssueCangeOpenedByOnUpdate(){

        acn__Issue__c newIssue = new acn__Issue__c();
        newIssue.acn__AssignedTo__c = contact.Id;
        newIssue.acn__OpenedBy__c = contact.Id;
        newIssue.acn__Headline__c = 'Test Headline';
        newIssue.acn__EstimatedTime__c = 50;
        newIssue.acn__StartDate__c = System.today().addDays(1);
        newIssue.acn__Status__c = 'Opened';
        newIssue.acn__Project__c = project.Id;
        newIssue.acn__Description__c = 'Test Issue';

        Contact contact2 = TestDataFactory.createContact('Test Contact 2', account.Id, UserInfo.getUserId());
        insert contact2;

        Test.startTest();
        try {
            insert newIssue; 
            newIssue.acn__OpenedBy__c = contact2.Id; //Contact2 no pertenece al proyecto y por tanto de deberia actualizarse
            update newIssue; // debe saltar al catch porque no puede actualizar el campo (el contacto 2 no es valido)
            System.assert(false, 'Esta linea no debería ejecutarse'); // si llega a esta linea es porque ha actualizado y al estar a "false" el test peta.
        } catch (Exception e) {
            System.assert(e.getMessage().contains(Label.IssueChangeOpenedByError), e.getMessage()); //El aser tiene una condición (contener el mensaje que queremos) Si no es ese mensaje es porque es otro error y saltara el que corresponda.
        }       
        Test.stopTest();
    }


}
