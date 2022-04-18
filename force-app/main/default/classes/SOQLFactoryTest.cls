@isTest
public with sharing class SOQLFactoryTest {
    @testSetup
    public static void testSetup() {
        Account acc = new Account();
        acc.Name = 'Test';
        acc.BillingCountry = 'ES';
        Account acc2 = new Account();
        acc2.Name = 'Test2';
        acc2.BillingCountry = 'ES';
        Account acc3 = new Account();
        acc3.Name = 'Test3';
        acc3.BillingCountry = 'ES';
        insert new List<Account>{ acc, acc2, acc3 };
    }

    @isTest
    public static void testQuery() {
        Test.startTest();
        Account acc = [Select Id
                       from Account
                       where Name = 'Test'];
        List<SOQLFactory.WhereCondition> conditions = new List<SOQLFactory.WhereCondition>();
        SOQLFactory.WhereCondition cond1 = new SOQLFactory.WhereCondition();
        cond1.field = 'BillingCountry';
        cond1.operator = '=';
        cond1.value = 'ES';
        SOQLFactory.WhereCondition cond2 = new SOQLFactory.WhereCondition();
        cond2.field = 'Name';
        cond2.operator = 'like';
        cond2.value = 'Te%';
        conditions.add(cond1);
        conditions.add(cond2);
        SOQLFactory.OrderBy order = new SOQLFactory.OrderBy();
        order.fields = new List<String>{ 'BillingCountry' };
        order.order = 'ASC';
        SOQLFactory.GroupBy grp1 = new SOQLFactory.GroupBy();
        grp1.fields = new List<String>{ 'BillingCountry' };
        grp1.havingCoditions = new List<SOQLFactory.WhereCondition>();
        SOQLFactory.WhereCondition having1 = new SOQLFactory.WhereCondition();
        having1.field = 'BillingCountry';
        having1.operator = '=';
        having1.value = 'ES';
        grp1.havingCoditions.add(having1);
        try {
            SOQLFactory.query('Account', new List<String>{ 'count(Id)', 'BillingCountry' }, conditions, '1 AND 2', grp1, order, 5);
            grp1.havingCoditions = new List<SOQLFactory.WhereCondition>();
            grp1.customLogic = '1';
            having1 = new SOQLFactory.WhereCondition();
            having1.field = 'BillingCountry';
            having1.operator = '!=';
            having1.value = null;
            grp1.havingCoditions.add(having1);
            SOQLFactory.query('Account', new List<String>{ 'count(Id)', 'ParentId' }, conditions, null, grp1, order, 5);
        } catch (AuraHandledException e) {

        }
        Test.stopTest();
    }

}