trigger IssueStatusOrderTrigger on acn__IssueStatusOrder__c (before insert, before update) {
    IssueStatusOrderTriggerHandler.getInstance().run(acn__IssueStatusOrder__c.sObjectType);
}