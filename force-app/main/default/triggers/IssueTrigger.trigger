trigger IssueTrigger on Issue__c (before insert, after insert, before update, after update) {
    IssueTriggerHandler.getInstance().run(Issue__c.SObjectType);

}