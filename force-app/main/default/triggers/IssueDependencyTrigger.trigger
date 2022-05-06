trigger IssueDependencyTrigger on acn__IssueDependency__c (before insert, before update) {

    IssueDependencyTriggerHandler.getInstance().run(acn__IssueDependency__c.SObjectType);
}