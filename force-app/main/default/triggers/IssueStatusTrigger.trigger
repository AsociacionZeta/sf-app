trigger IssueStatusTrigger on acn__IssueStatus__c (before insert, before update) {
    IssueStatusTriggerHandler.getInstance().run(acn__IssueStatus__c.sObjectType);
}