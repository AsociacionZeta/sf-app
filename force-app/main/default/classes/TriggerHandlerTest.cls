@isTest
public with sharing class TriggerHandlerTest {
    public static Account acc {
        get {
            if (acc == null) {
                acc = [Select Id
                       from Account
                       where Name = 'Test'];
            }
            return acc;
        }

        set;
    }

    @testSetup
    public static void testSetup() {
        acc = new Account();
        acc.Name = 'Test';
        acc.BillingCountry = 'ES';
        insert acc;
    }

    @isTest
    public static void testBeforeInsert() {
        TriggerTest instance = new TriggerTest();
        TriggerHandler.limitTrigger(Account.sObjectType, 1);
        instance.operationType = TriggerOperation.BEFORE_INSERT;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
        TriggerHandler.bypass(Account.sObjectType);
        TriggerHandler.isBypassed(Account.sObjectType);
        TriggerHandler.removeBypass(Account.sObjectType);
        TriggerHandler.removeAllBypasses();
        TriggerHandler.clearLimit(Account.sObjectType);
    }

    @isTest
    public static void testAfterInsert() {
        TriggerTest instance = new TriggerTest();
        instance.operationType = TriggerOperation.AFTER_INSERT;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
    }

    @isTest
    public static void testBeforeUpdate() {
        TriggerTest instance = new TriggerTest();
        instance.operationType = TriggerOperation.BEFORE_UPDATE;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
    }

    @isTest
    public static void testAfterUpdate() {
        TriggerTest instance = new TriggerTest();
        instance.operationType = TriggerOperation.AFTER_UPDATE;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
    }

    @isTest
    public static void testBeforeDelete() {
        TriggerTest instance = new TriggerTest();
        instance.operationType = TriggerOperation.BEFORE_DELETE;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
    }

    @isTest
    public static void testAfterDelete() {
        TriggerTest instance = new TriggerTest();
        instance.operationType = TriggerOperation.AFTER_DELETE;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
    }

    @isTest
    public static void testAfterUndelete() {
        TriggerTest instance = new TriggerTest();
        instance.operationType = TriggerOperation.AFTER_UNDELETE;
        instance.newList = new List<SObject>();
        instance.newList.add(acc);
        instance.newMap = new Map<Id, SObject>();
        instance.newMap.put(acc.Id, acc);
        instance.oldMap = new Map<Id, SObject>();
        instance.oldMap.put(acc.Id, acc);
        instance.run(Account.sObjectType);
    }

    public class TriggerTest extends TriggerHandler {
        public TriggerTest() {
        }

    }

}