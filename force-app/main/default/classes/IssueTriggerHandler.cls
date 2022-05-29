public without sharing class IssueTriggerHandler extends TriggerHandler {
    private static IssueTriggerHandler singleton;
    private Map<Id, acn__Project__c> projectMap = new Map<Id, acn__Project__c>();
    private Map<Id, acn__Project__c> projectsToUpdate = new Map<Id, acn__Project__c>();
    private Map<Id, List<acn__ProjectCollaborator__c>> projectCollaboratorByProject = new Map<Id, List<acn__ProjectCollaborator__c>>();
    private Map<Id, Set<Id>> projectCollaboratorContactIdsByProject = new Map<Id, Set<Id>>();
    private Map<Id, Map<Id, acn__IssueStatus__c>> statusByProjectMap = new Map<Id, Map<Id, acn__IssueStatus__c>>();
    private Map<Id, acn__IssueStatus__c> allStatusMap = new Map<Id, acn__IssueStatus__c>();
    private Map<Id, acn__IssueStatus__c> initialStatusByProjectMap = new Map<Id, acn__IssueStatus__c>();
    private Map<Id, acn__IssueStatusOrder__c> allIsueStatusOrderMap = new Map<Id, acn__IssueStatusOrder__c>();
    private Map<Id, Map<Id, acn__IssueStatusOrder__c>> changeToOrderByOriginStatusMap = new Map<Id, Map<Id, acn__IssueStatusOrder__c>>();
    private Map<Id, Map<Id, acn__IssueStatusOrder__c>> originStatusOrderByChangeToMap = new Map<Id, Map<Id, acn__IssueStatusOrder__c>>();
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
            acn__Issue__c newIssue = (acn__Issue__c)newRecord;
            if (!projectMap.containsKey(newIssue.acn__Project__c)) {
                projectIds.add(newIssue.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newMap.values()) {
            acn__Issue__c newIssue = (acn__Issue__c)newRecord;
            acn__Issue__c oldIssue = (acn__Issue__c)oldMap.get(newIssue.Id);
            if (!projectMap.containsKey(newIssue.acn__Project__c)) {
                projectIds.add(newIssue.acn__Project__c);
            }
            if (!projectMap.containsKey(oldIssue.acn__Project__c)) {
                projectIds.add(oldIssue.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void beforeInsert(SObject newRecord) {
        acn__Issue__c newIssue = (acn__Issue__c)newRecord; //casting (pasamos de un SObject "genérico) al SObject concreto (en este caso el Objeto Issue)
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        acn__IssueStatus__c initialStatus = initialStatusByProjectMap.get(newIssue.acn__Project__c);
        Set<Id> projectCollaboratorContactIds = projectCollaboratorContactIdsByProject.get(newIssue.acn__Project__c);
        IssueTriggerHelper.setIssueName(newIssue, project);
        IssueTriggerHelper.setInitialStatus(newIssue, initialStatus);
        IssueTriggerHelper.validateIssueOpenedBy(newIssue, projectCollaboratorContactIds);
        IssueTriggerHelper.validateIssueAssigment(newIssue, projectCollaboratorContactIds);
    }

    public override void afterInsert(SObject newRecord) {
        acn__Issue__c newIssue = (acn__Issue__c)newRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        ProjectTriggerHandler.allowModifyIssueCount = true;
        IssueTriggerHelper.incrementIssueCount(project);
        projectsToUpdate.put(project.Id, project);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord) {
        acn__Issue__c newIssue = (acn__Issue__c)newRecord;
        acn__Issue__c oldIssue = (acn__Issue__c)oldRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        Map<Id, acn__IssueStatus__c> statusFromProject = statusByProjectMap.get(newIssue.acn__Project__c);
        Map<Id, acn__IssueStatusOrder__c> statusOrderByChangeTo = changeToOrderByOriginStatusMap.get(oldIssue.acn__Status__c);
        if(statusOrderByChangeTo == null){
            statusOrderByChangeTo = new Map<Id, acn__IssueStatusOrder__c>();
        }
        Set<Id> projectCollaboratorContactIds = projectCollaboratorContactIdsByProject.get(newIssue.acn__Project__c);
        if (newIssue.acn__Project__c != oldIssue.acn__Project__c) {
            IssueTriggerHelper.setIssueName(newIssue, project);
        }
        IssueTriggerHelper.setPreviousAssignment(newIssue, oldIssue);
        IssueTriggerHelper.validateStatus(newIssue, oldIssue, statusFromProject, statusOrderByChangeTo.keySet());
        IssueTriggerHelper.assingIssue(newIssue, oldIssue, statusOrderByChangeTo);
        IssueTriggerHelper.preventChangeOpenedBy(newIssue, oldIssue);
        IssueTriggerHelper.validateIssueAssigment(newIssue, projectCollaboratorContactIds);
    }

    public override void afterUpdate(SObject newRecord, SObject oldRecord) {
        acn__Issue__c newIssue = (acn__Issue__c)newRecord;
        acn__Issue__c oldIssue = (acn__Issue__c)oldRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        acn__Project__c oldProject = projectMap.get(oldIssue.acn__Project__c);
        if (newIssue.acn__Project__c != oldIssue.acn__Project__c) {
            ProjectTriggerHandler.allowModifyIssueCount = true;
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
            ProjectTriggerHandler.allowModifyIssueCount = false;
        }
    }

    private void getProjectData(Set<Id> projectIds) {
        if (projectIds.size() > 0) {
            Set<Id> tmpIds = CollectionUtils.mergeSet(projectIds, projectMap.keySet());
            projectMap = new Map<Id, acn__Project__c>([Select Id, Name, acn__Code__c, acn__IssuesCount__c
                                                       from acn__Project__c
                                                       where Id in:tmpIds]);

            for (acn__ProjectCollaborator__c projectCollaborator : [Select Id, acn__Project__c, acn__Contact__c
                                                                    from acn__ProjectCollaborator__c
                                                                    where acn__Project__c in:projectMap.keySet()]) {
                if (!projectCollaboratorByProject.containsKey(projectCollaborator.acn__Project__c)) {
                    projectCollaboratorByProject.put(projectCollaborator.acn__Project__c, new List<acn__ProjectCollaborator__c>());
                }
                projectCollaboratorByProject.get(projectCollaborator.acn__Project__c).add(projectCollaborator);

                if (!projectCollaboratorContactIdsByProject.containsKey(projectCollaborator.acn__Project__c)) {
                    projectCollaboratorContactIdsByProject.put(projectCollaborator.acn__Project__c, new Set<Id>());
                }
                projectCollaboratorContactIdsByProject.get(projectCollaborator.acn__Project__c).add(projectCollaborator.acn__Contact__c);
            }
            allStatusMap = new Map<Id, acn__IssueStatus__c>([Select Id, Name, acn__Project__c, Active__c, Initial__c
                                                             from acn__IssueStatus__c
                                                             where acn__Project__c in:projectMap.keySet()]);
            for (acn__IssueStatus__c status : allStatusMap.values()) {
                if (status.acn__Active__c && status.acn__Initial__c) {
                    initialStatusByProjectMap.put(status.acn__Project__c, status);
                }
                if (!statusByProjectMap.containsKey(status.acn__Project__c)) {
                    statusByProjectMap.put(status.acn__Project__c, new Map<Id, acn__IssueStatus__c>());
                }
                statusByProjectMap.get(status.acn__Project__c).put(status.Id, status);
            }
            allIsueStatusOrderMap = new Map<Id, acn__IssueStatusOrder__c>([Select Id, acn__Status__c, acn__ChangeTo__c, acn__AssignTo__c
                                                                           from acn__IssueStatusOrder__c
                                                                           where acn__Status__c in:allStatusMap.keySet() OR acn__ChangeTo__c in:allStatusMap.keySet()]);
            changeToOrderByOriginStatusMap = new Map<Id, Map<Id, acn__IssueStatusOrder__c>>();
            originStatusOrderByChangeToMap = new Map<Id, Map<Id, acn__IssueStatusOrder__c>>();
            for (acn__IssueStatusOrder__c statusOrder : allIsueStatusOrderMap.values()) {
                if (!changeToOrderByOriginStatusMap.containsKey(statusOrder.acn__Status__c)) {
                    changeToOrderByOriginStatusMap.put(statusOrder.acn__Status__c, new Map<Id, acn__IssueStatusOrder__c>());
                }
                changeToOrderByOriginStatusMap.get(statusOrder.acn__Status__c).put(statusOrder.acn__ChangeTo__c, statusOrder);
                if (!originStatusOrderByChangeToMap.containsKey(statusOrder.acn__ChangeTo__c)) {
                    originStatusOrderByChangeToMap.put(statusOrder.acn__ChangeTo__c, new Map<Id, acn__IssueStatusOrder__c>());
                }
                originStatusOrderByChangeToMap.get(statusOrder.acn__ChangeTo__c).put(statusOrder.acn__Status__c, statusOrder);
            }
        }
    }

}