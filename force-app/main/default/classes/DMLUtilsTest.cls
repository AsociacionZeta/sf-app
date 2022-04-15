@isTest
public with sharing class DMLUtilsTest {
    public static Account acc {
        get {
            if (acc == null) {
                acc = [Select Id, Name
                       from Account
                       where Name = 'Test'];
            }
            return acc;
        }

        set;
    }

    public static Account acc2 {
        get {
            if (acc2 == null) {
                acc2 = [Select Id, Name
                        from Account
                        where Name = 'Test2'];
            }
            return acc2;
        }

        set;
    }

    @testSetup
    public static void setupTest() {
        acc = new Account();
        acc.Name = 'Test4';
        acc.BillingCountry = 'ES';
        acc2 = new Account();
        acc2.Name = 'Test2';
        acc2.BillingCountry = 'ES';
        insert new List<Account>{ acc, acc2 };
    }

    @isTest
    public static void testInsert() {
        Account acc3 = new Account();
        acc3.Name = 'Test3';
        acc3.BillingCountry = 'ES';
        DMLUtils.insertDML(acc3);
        Account acc4 = new Account();
        acc4.Name = 'Test4';
        acc4.BillingCountry = 'ES';
        DMLUtils.insertDML(new List<SObject>{ acc4 });
    }

    @isTest
    public static void testUpdate() {
        DMLUtils.updateDML(acc);
        DMLUtils.updateDML(new List<SObject>{ acc2 });
    }

    @isTest
    public static void testDelete() {
        Account acc5 = new Account();
        acc5.Name = 'Test5';
        acc5.BillingCountry = 'ES';
        DMLUtils.insertDML(acc5);
        Account acc6 = new Account();
        acc6.Name = 'Test6';
        acc6.BillingCountry = 'ES';
        DMLUtils.insertDML(new List<SObject>{ acc6 });
        DMLUtils.deleteDML(acc5);
        DMLUtils.deleteDML(new List<SObject>{ acc6 });
    }

    @isTest
    public static void testCreateRecords() {
        DMLUtils.Record record = new DMLUtils.Record();
        record.apiName = 'Task';
        record.fields = new Map<String, Object>();
        record.fields.put('Description', 'test');
        record.fields.put('ActivityDate', system.today());
        record.fields.put('Email', 'test@test.com');
        record.fields.put('Phone', '659865456');
        record.fields.put('Priority', 'High');
        record.fields.put('Subject', 'Call');
        List<DMLUtils.Record> records = new List<DMLUtils.Record>();
        records.add(record);
        DMLUtils.createRecords(records);
    }

    @isTest
    public static void testUpdateRecords() {
        DMLUtils.Record record = new DMLUtils.Record();
        record.apiName = 'Task';
        record.fields = new Map<String, Object>();
        record.fields.put('Description', 'test');
        record.fields.put('ActivityDate', system.today());
        record.fields.put('Email', 'test@test.com');
        record.fields.put('Phone', '659865456');
        record.fields.put('Priority', 'High');
        record.fields.put('Subject', 'Call');
        List<DMLUtils.Record> records = new List<DMLUtils.Record>();
        records.add(record);
        List<SObject> result = DMLUtils.createRecords(records);
        records.clear();
        record.fields.put('Id', result[0].Id);
        records.add(record);
        DMLUtils.updateRecords(records);
    }

    @isTest
    public static void testDeleteRecords() {
        DMLUtils.Record record = new DMLUtils.Record();
        record.apiName = 'Task';
        record.fields = new Map<String, Object>();
        record.fields.put('Description', 'test');
        record.fields.put('ActivityDate', system.today());
        record.fields.put('Email', 'test@test.com');
        record.fields.put('Phone', '659865456');
        record.fields.put('Priority', 'High');
        record.fields.put('Subject', 'Call');
        List<DMLUtils.Record> records = new List<DMLUtils.Record>();
        records.add(record);
        List<SObject> result = DMLUtils.createRecords(records);
        records.clear();
        record.fields.put('Id', result[0].Id);
        records.add(record);
        DMLUtils.deleteRecords(records);
    }

    @isTest
    public static void testUpsertRecords() {
        DMLUtils.Record record = new DMLUtils.Record();
        record.apiName = 'Task';
        record.fields = new Map<String, Object>();
        record.fields.put('Description', 'test');
        record.fields.put('ActivityDate', system.today());
        record.fields.put('Email', 'test@test.com');
        record.fields.put('Phone', '659865456');
        record.fields.put('Priority', 'High');
        record.fields.put('Subject', 'Call');
        List<DMLUtils.Record> records = new List<DMLUtils.Record>();
        records.add(record);
        DMLUtils.upsertRecords(records);
    }

}