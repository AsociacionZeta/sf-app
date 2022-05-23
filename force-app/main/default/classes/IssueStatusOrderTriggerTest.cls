@isTest
public with sharing class IssueStatusOrderTriggerTest {
    private static acn__Project__c project {
        get {
            if (project == null) {
                project = [Select Id
                           from acn__Project__c
                           where acn__Code__c = 'TEST'];
            }
            return project;
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

    private static acn__IssueStatus__c originStatus {
        get {
            if (originStatus == null) {
                originStatus = [Select Id, Name
                                from acn__IssueStatus__c
                                where Name = 'Origin'];
            }
            return originStatus;
        }

        set;
    }

    private static acn__IssueStatus__c changeToStatus {
        get {
            if (changeToStatus == null) {
                changeToStatus = [Select Id, Name
                                  from acn__IssueStatus__c
                                  where Name = 'Change To'];
            }
            return changeToStatus;
        }

        set;
    }

    @TestSetup
    public static void testSetup() {
        Account account = TestDataFactory.createAccount('Test Account');
        insert account;
        contact = TestDataFactory.createContact('Test Contact', account.Id, UserInfo.getUserId());
        insert contact;
        project = TestDataFactory.createProject('Test Project', 'TEST', contact.Id);
        insert project;
        originStatus = TestDataFactory.createIssueStatus('Origin', project.Id, 'opened', true);
        changeToStatus = TestDataFactory.createIssueStatus('Change To', project.Id, 'progress', false);
        insert new List<acn__IssueStatus__c>{ originStatus, changeToStatus };
    }

    @isTest
    public static void testInsert() {
        acn__IssueStatusOrder__c statusOrder = new acn__IssueStatusOrder__c();
        statusOrder.acn__Status__c = originStatus.Id;
        statusOrder.acn__ChangeTo__c = changeToStatus.Id;
        Test.startTest();
        insert statusOrder;
        Test.stopTest();

        acn__IssueStatusOrder__c orderResult = [Select Id, Name, acn__UniqueKey__c
                                                from acn__IssueStatusOrder__c
                                                where Id = :statusOrder.Id];
        System.assertEquals(originStatus.Id + '_' + changeToStatus.Id, orderResult.acn__UniqueKey__c);
        System.assertEquals(originStatus.Name + ' to ' + changeToStatus.Name, orderResult.Name);
    }

    @isTest
    public static void testUpdate() {
        acn__IssueStatus__c changeToStatus2 = TestDataFactory.createIssueStatus('Change To 2', project.Id, 'progress', false);
        insert changeToStatus2;
        acn__IssueStatusOrder__c statusOrder = new acn__IssueStatusOrder__c();
        statusOrder.acn__Status__c = originStatus.Id;
        statusOrder.acn__ChangeTo__c = changeToStatus.Id;
        
        Test.startTest();
        insert statusOrder;
        statusOrder.acn__ChangeTo__c = changeToStatus2.Id;
        update statusOrder;
        Test.stopTest();

        acn__IssueStatusOrder__c orderResult = [Select Id, Name, acn__UniqueKey__c
                                                from acn__IssueStatusOrder__c
                                                where Id = :statusOrder.Id];
        System.assertEquals(originStatus.Id + '_' + changeToStatus2.Id, orderResult.acn__UniqueKey__c);
        System.assertEquals(originStatus.Name + ' to ' + changeToStatus2.Name, orderResult.Name);
    }
    
    @isTest
    public static void testValidateStatusAndChangeToProject() {
        acn__Project__c project2 = TestDataFactory.createProject('Test Project 2', 'TEST2', contact.Id);
        insert project2;
        acn__IssueStatus__c changeToStatus2 = TestDataFactory.createIssueStatus('Change To 2', project2.Id, 'progress', false);
        insert changeToStatus2;
        acn__IssueStatusOrder__c statusOrder = new acn__IssueStatusOrder__c();
        statusOrder.acn__Status__c = originStatus.Id;
        statusOrder.acn__ChangeTo__c = changeToStatus2.Id;
        Test.startTest();
        try {
            insert statusOrder;
            system.assert(false, 'Esta línea no deberia ejecutarse');
        } catch (Exception e) {
            system.assert(e.getMessage().contains(Label.StatusAndChangeToProjectError), e.getMessage());
        }
        Test.stopTest();
    }

    @isTest
    public static void testRetrictModifyName() {
        acn__IssueStatusOrder__c statusOrder = new acn__IssueStatusOrder__c();
        statusOrder.acn__Status__c = originStatus.Id;
        statusOrder.acn__ChangeTo__c = changeToStatus.Id;
        
        Test.startTest();
        insert statusOrder;
        try {
            statusOrder.Name = 'test';
            update statusOrder;
            system.assert(false, 'Esta línea no deberia ejecutarse');
        } catch (Exception e) {
            system.assert(e.getMessage().contains(Label.NameFieldIsNotEditable), e.getMessage());
        }
        Test.stopTest();
    }
}