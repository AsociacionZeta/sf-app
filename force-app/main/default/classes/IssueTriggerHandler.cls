public without sharing class IssueTriggerHandler extends TriggerHandler {
    private static IssueTriggerHandler singleton;
    private Map<Id, acn__Project__c> projectMap = new Map<Id, acn__Project__c>();
    private Map<Id, acn__Project__c> projectsToUpdate = new Map<Id, acn__Project__c>();
    private IssueTriggerHandler() {
    }

    public static IssueTriggerHandler getInstance() {
        if (singleton == null) {
            singleton = new IssueTriggerHandler();
        }
        return singleton;
    }

    public override void bulkInsert(List<SObject> newList) {
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newList) {
            acn__Issue__c newIssue = (acn__Issue__c) newRecord;
            if (!projectMap.containsKey(newIssue.acn__Project__c)) {
                projectIds.add(newIssue.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newMap.values()) {
            acn__Issue__c newIssue = (acn__Issue__c) newRecord;
            acn__Issue__c oldIssue = (acn__Issue__c) oldMap.get(newIssue.Id);
            projectIds.add(newIssue.acn__Project__c);
            projectIds.add(oldIssue.acn__Project__c);
        }
        getProjectData(projectIds);
    }

    public override void beforeInsert(SObject newRecord) {
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        IssueTriggerHelper.setIssueName(newIssue, project);
    }

    public override void afterInsert(SObject newRecord) {
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        IssueTriggerHelper.incrementIssueCount(project);
        projectsToUpdate.put(project.Id, project);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord) {
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Issue__c oldIssue = (acn__Issue__c) oldRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        if (newIssue.acn__Project__c != oldIssue.acn__Project__c) {
            IssueTriggerHelper.setIssueName(newIssue, project);
        }
    }

    public override void afterUpdate(SObject newRecord, SObject oldRecord) {
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Issue__c oldIssue = (acn__Issue__c) oldRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        acn__Project__c oldProject = projectMap.get(oldIssue.acn__Project__c);
        if (newIssue.acn__Project__c != oldIssue.acn__Project__c) {
            IssueTriggerHelper.incrementIssueCount(project);
            IssueTriggerHelper.decrementIssueCount(oldProject);
            projectsToUpdate.put(project.Id, project);
            projectsToUpdate.put(oldProject.Id, oldProject);
        }
    }

    public override void onFinally() {
        if (projectsToUpdate.size() > 0) {
            update projectsToUpdate.values();
            projectsToUpdate.clear();
        }
    }

    private void getProjectData(Set<Id> projectIds) {
        if (projectIds.size() > 0) {
            Set<Id> tmpIds = CollectionUtils.mergeSet(projectIds, projectMap.keySet());
            projectMap = new Map<Id, acn__Project__c>([Select Id, Name, acn__Code__c, acn__IssuesCount__c
                                                       from acn__Project__c
                                                       where Id in:tmpIds]);
        }
    }

}