public without sharing class IssueStatusTriggerHandler extends TriggerHandler {
    private static IssueStatusTriggerHandler singleton;
    private Map<Id, List<acn__IssueStatus__c>> issueStatusesByProject = new Map<Id, List<acn__IssueStatus__c>>();
    private IssueStatusTriggerHandler() {
    }

    public static IssueStatusTriggerHandler getInstance() {
        if (singleton == null) {
            singleton = new IssueStatusTriggerHandler();
        }
        return singleton;
    }

    public override void bulkInsert(List<SObject> newList){
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newList){
            acn__IssueStatus__c newIssueStatus = (acn__IssueStatus__c) newRecord;
            if (!issueStatusesByProject.containsKey(newIssueStatus.acn__Project__c)){
                projectIds.add(newIssueStatus.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newMap.values()){
            acn__IssueStatus__c newIssueStatus = (acn__IssueStatus__c) newRecord;
            acn__IssueStatus__c oldIssueStatus = (acn__IssueStatus__c) oldMap.get(newIssueStatus.Id);
            if (!issueStatusesByProject.containsKey(newIssueStatus.acn__Project__c)){
                projectIds.add(newIssueStatus.acn__Project__c);
            }
            if (!issueStatusesByProject.containsKey(oldIssueStatus.acn__Project__c)){
                projectIds.add(oldIssueStatus.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void beforeInsert(SObject newRecord){
        acn__IssueStatus__c newIssueStatus = (acn__IssueStatus__c) newRecord;
        List<acn__IssueStatus__c> issueStatusFromProject = issueStatusesByProject.get(newIssueStatus.acn__Project__c);
        IssueStatusTriggerHelper.validateInitialProject(newIssueStatus, null, issueStatusFromProject);
        IssueStatusTriggerHelper.validateStatusName(newIssueStatus, null, issueStatusFromProject);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord){
        acn__IssueStatus__c newIssueStatus = (acn__IssueStatus__c) newRecord;
        acn__IssueStatus__c oldIssueStatus = (acn__IssueStatus__c) oldRecord;
        List<acn__IssueStatus__c> issueStatusFromProject = issueStatusesByProject.get(newIssueStatus.acn__Project__c);
        IssueStatusTriggerHelper.validateInitialProject(newIssueStatus, oldIssueStatus, issueStatusFromProject);
        IssueStatusTriggerHelper.validateStatusName(newIssueStatus, oldIssueStatus, issueStatusFromProject);
    }

    private void getProjectData(Set<Id> projectIds) {
        if (projectIds.size() > 0) {
            Set<Id> tmpIds = CollectionUtils.mergeSet(projectIds, issueStatusesByProject.keySet());
            issueStatusesByProject = new Map<Id, List<acn__IssueStatus__c>>();
            for (acn__IssueStatus__c issueStatus : [Select Id, Name, acn__Project__c, acn__Active__c
                                                    from acn__IssueStatus__c
                                                    where acn__Project__c in:tmpIds]) {
                if (!issueStatusesByProject.containsKey(issueStatus.acn__Project__c)) {
                    issueStatusesByProject.put(issueStatus.acn__Project__c, new List<acn__IssueStatus__c>());
                }
                issueStatusesByProject.get(issueStatus.acn__Project__c).add(issueStatus);
            }
        }
    }

}