@isTest
public with sharing class IssueStatusTriggerTest {

    private static acn__Project__c project {
        get {
            if(project == null){
                project = [Select Id from acn__Project__c where acn__Code__c = 'TEST'];
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
        project = TestDataFactory.createProject('Test Project', 'TEST', contact.Id);
        insert project;
    }

    @isTest
    public static void testValidateInitialProjectOnInsert(){
        acn__IssueStatus__c status = new acn__IssueStatus__c();
        status.Name = 'Opened';
        status.acn__Project__c = project.Id;
        status.acn__Active__c = true;
        status.acn__Initial__c = true;
        status.acn__Type__c = 'opened';
        insert status;

        acn__IssueStatus__c status2 = new acn__IssueStatus__c();
        status2.Name = 'In Progress';
        status2.acn__Project__c = project.Id;
        status2.acn__Active__c = true;
        status2.acn__Initial__c = true;
        status2.acn__Type__c = 'opened';
        Test.startTest();
        try {
            insert status2;
            system.assert(false, 'Esta línea no deberia ejecutarse');
        } catch (Exception e) {
            system.assert(e.getMessage().contains(Label.TwoInitialStatusByProjectError), e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void testValidateInitialProjectOnUpdate(){
        acn__IssueStatus__c status = new acn__IssueStatus__c();
        status.Name = 'Opened';
        status.acn__Project__c = project.Id;
        status.acn__Active__c = true;
        status.acn__Initial__c = true;
        status.acn__Type__c = 'opened';
        insert status;

        acn__IssueStatus__c status2 = new acn__IssueStatus__c();
        status2.Name = 'In Progress';
        status2.acn__Project__c = project.Id;
        status2.acn__Active__c = true;
        status2.acn__Initial__c = false;
        status2.acn__Type__c = 'opened';
        insert status2;
        Test.startTest();
        try {
            status2.acn__Initial__c = true;
            update status2;
            system.assert(false, 'Esta línea no deberia ejecutarse');
        } catch (Exception e) {
            system.assert(e.getMessage().contains(Label.TwoInitialStatusByProjectError), e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void testValidateStatusNameOnInsert(){
        acn__IssueStatus__c status = new acn__IssueStatus__c();
        status.Name = 'Opened';
        status.acn__Project__c = project.Id;
        status.acn__Active__c = true;
        status.acn__Initial__c = true;
        status.acn__Type__c = 'opened';
        insert status;

        acn__IssueStatus__c status2 = new acn__IssueStatus__c();
        status2.Name = 'Opened';
        status2.acn__Project__c = project.Id;
        status2.acn__Active__c = true;
        status2.acn__Initial__c = false;
        status2.acn__Type__c = 'opened';
        Test.startTest();
        try {
            insert status2;
            system.assert(false, 'Esta línea no deberia ejecutarse');
        } catch (Exception e) {
            system.assert(e.getMessage().contains(Label.TwoEqualStatusOnProjectError), e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void testValidateStatusNameOnUpdate(){
        acn__IssueStatus__c status = new acn__IssueStatus__c();
        status.Name = 'Opened';
        status.acn__Project__c = project.Id;
        status.acn__Active__c = true;
        status.acn__Initial__c = true;
        status.acn__Type__c = 'opened';
        insert status;

        acn__IssueStatus__c status2 = new acn__IssueStatus__c();
        status2.Name = 'Progress';
        status2.acn__Project__c = project.Id;
        status2.acn__Active__c = true;
        status2.acn__Initial__c = false;
        status2.acn__Type__c = 'opened';
        insert status2;
        Test.startTest();
        try {
            status2.Name = 'Opened';
            update status2;
            system.assert(false, 'Esta línea no deberia ejecutarse');
        } catch (Exception e) {
            system.assert(e.getMessage().contains(Label.TwoEqualStatusOnProjectError), e.getMessage());
        }
        Test.stopTest();
    }

}
