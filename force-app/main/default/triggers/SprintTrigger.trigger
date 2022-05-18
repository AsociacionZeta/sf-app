trigger SprintTrigger on acn__Sprint__c (before insert, before update) {
    SprintTriggerHandler.getInstance().run(acn__Sprint__c.SObjectType);

}