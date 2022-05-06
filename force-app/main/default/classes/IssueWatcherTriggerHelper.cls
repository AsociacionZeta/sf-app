public with sharing class IssueWatcherTriggerHelper {
    
    public static void setUniqueKey (acn__IssueWatcher__c newIssueWatcher){
        newIssueWatcher.acn__UniqueKey__c = newIssueWatcher.acn__Issue__c + '_' + newIssueWatcher.acn__Contact__c;
    }
}
