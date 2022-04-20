trigger ProjectTrigger on acn__Project__c (before insert, before update) {

    ProjectTriggerHandler.getInstance().run(acn__Project__c.sObjectType);

}