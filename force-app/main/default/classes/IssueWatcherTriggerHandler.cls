public without sharing class IssueWatcherTriggerHandler extends TriggerHandler{
    private static IssueWatcherTriggerHandler singleton;

    public IssueWatcherTriggerHandler() {

    }

    public static IssueWatcherTriggerHandler getInstance (){
        if(singleton == null){
            singleton = new IssueWatcherTriggerHandler();           
        }
        return singleton; 
    }

    public override void beforeInsert(SObject newRecord){
        acn__IssueWatcher__c newIssueWatcher = (acn__IssueWatcher__c) newRecord;
        IssueWatcherTriggerHelper.setUniqueKey(newIssueWatcher);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord){
        acn__IssueWatcher__c newIssueWatcher = (acn__IssueWatcher__c) newRecord;
        acn__IssueWatcher__c oldIssueWatcher = (acn__IssueWatcher__c) oldRecord;
        IssueWatcherTriggerHelper.setUniqueKey(newIssueWatcher);
    }
}
