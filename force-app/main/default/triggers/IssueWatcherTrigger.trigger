trigger IssueWatcherTrigger on acn__IssueWatcher__c (before insert, before update) {
    IssueWatcherTriggerHandler.getInstance().run(acn__IssueWatcher__c.SObjectType);

}