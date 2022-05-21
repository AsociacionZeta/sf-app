public without sharing class IssueTriggerHandler extends TriggerHandler{
    private static IssueTriggerHandler singleton;
    private Map<Id, acn__Project__c> projectMap = new Map<Id, acn__Project__c>();
    private Map<Id, acn__Project__c> projectsToUpdate = new Map<Id, acn__Project__c>();
    private Map<Id, List<acn__ProjectCollaborator__c>> projectCollaboratorByProject = new Map<Id, List<acn__ProjectCollaborator__c>>();
    private Map<Id, Set<Id>> projectCollaboratorContactIdsByProject = new Map<Id, Set<Id>>();
    private IssueTriggerHandler(){
    }

    public static IssueTriggerHandler getInstance(){
        if (singleton == null){
            singleton = new IssueTriggerHandler();
        }
        return singleton;
    }

    public override void bulkInsert(List<SObject> newList){
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newList){
            acn__Issue__c newIssue = (acn__Issue__c) newRecord;
            if (!projectMap.containsKey(newIssue.acn__Project__c)){
                projectIds.add(newIssue.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newMap.values()){
            acn__Issue__c newIssue = (acn__Issue__c) newRecord;
            acn__Issue__c oldIssue = (acn__Issue__c) oldMap.get(newIssue.Id);
            if (!projectMap.containsKey(newIssue.acn__Project__c)){
                projectIds.add(newIssue.acn__Project__c);
            }
            if (!projectMap.containsKey(oldIssue.acn__Project__c)){
                projectIds.add(oldIssue.acn__Project__c);
            }
        }
        getProjectData(projectIds);
    }

    public override void beforeInsert(SObject newRecord){
        acn__Issue__c newIssue = (acn__Issue__c) newRecord; //casting (pasamos de un SObject "genérico) al SObject concreto (en este caso el Objeto Issue)
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        Set<Id> projectCollaboratorContactIds = projectCollaboratorContactIdsByProject.get(newIssue.acn__Project__c);
        IssueTriggerHelper.setIssueName(newIssue, project);
        IssueTriggerHelper.validateIssueOpenedBy(newIssue, projectCollaboratorContactIds);
        IssueTriggerHelper.validateIssueAssigment(newIssue, projectCollaboratorContactIds);
    }

    public override void afterInsert(SObject newRecord){
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        ProjectTriggerHandler.allowModifyIssueCount = true;
        IssueTriggerHelper.incrementIssueCount(project);
        projectsToUpdate.put(project.Id, project);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord){
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Issue__c oldIssue = (acn__Issue__c) oldRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        Set<Id> projectCollaboratorContactIds = projectCollaboratorContactIdsByProject.get(newIssue.acn__Project__c);
        if (newIssue.acn__Project__c != oldIssue.acn__Project__c){
            IssueTriggerHelper.setIssueName(newIssue, project);
        }
        IssueTriggerHelper.preventChangeOpenedBy(newIssue, oldIssue); 
        IssueTriggerHelper.validateIssueAssigment(newIssue, projectCollaboratorContactIds);
    }

    public override void afterUpdate(SObject newRecord, SObject oldRecord){
        acn__Issue__c newIssue = (acn__Issue__c) newRecord;
        acn__Issue__c oldIssue = (acn__Issue__c) oldRecord;
        acn__Project__c project = projectMap.get(newIssue.acn__Project__c);
        acn__Project__c oldProject = projectMap.get(oldIssue.acn__Project__c);
        if (newIssue.acn__Project__c != oldIssue.acn__Project__c){
            ProjectTriggerHandler.allowModifyIssueCount = true;
            IssueTriggerHelper.incrementIssueCount(project);
            IssueTriggerHelper.decrementIssueCount(oldProject);
            projectsToUpdate.put(project.Id, project);
            projectsToUpdate.put(oldProject.Id, oldProject);
        }
    }

    public override void onFinally(){
        if (projectsToUpdate.size() > 0){
            update projectsToUpdate.values();
            projectsToUpdate.clear();
            ProjectTriggerHandler.allowModifyIssueCount = false;
        }
    }

    private void getProjectData(Set<Id> projectIds){
        if (projectIds.size() > 0){
            Set<Id> tmpIds = CollectionUtils.mergeSet(projectIds, projectMap.keySet());
            projectMap = new Map<Id, acn__Project__c>([Select Id, Name, acn__Code__c, acn__IssuesCount__c
                                                       from acn__Project__c
                                                       where Id in:tmpIds]);

            for (acn__ProjectCollaborator__c projectCollaborator : [Select Id, acn__Project__c, acn__Contact__c
                                                                    from acn__ProjectCollaborator__c
                                                                    where acn__Project__c in:projectMap.keySet()]){
                if (!projectCollaboratorByProject.containsKey(projectCollaborator.acn__Project__c)){
                    projectCollaboratorByProject.put(projectCollaborator.acn__Project__c, new List<acn__ProjectCollaborator__c>());
                }
                projectCollaboratorByProject.get(projectCollaborator.acn__Project__c).add(projectCollaborator);

                if (!projectCollaboratorContactIdsByProject.containsKey(projectCollaborator.acn__Project__c)){
                    projectCollaboratorContactIdsByProject.put(projectCollaborator.acn__Project__c, new Set<Id>());
                }
                projectCollaboratorContactIdsByProject.get(projectCollaborator.acn__Project__c).add(projectCollaborator.acn__Contact__c);
            }
        }
    }

}