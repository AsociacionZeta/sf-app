public with sharing class SprintTriggerHandler extends TriggerHandler{
    private static SprintTriggerHandler singleton;
    private Map<Id, acn__Sprint__c> sprintMap = new Map<Id, acn__Sprint__c>();
    private Map<Id, List<acn__Sprint__c>> sprintByProjectMap = new Map<Id, List<acn__Sprint__c>>();
    public SprintTriggerHandler(){
    }

    public static SprintTriggerHandler getInstance(){

        if (singleton == null){
            singleton = new SprintTriggerHandler();
        }
        return singleton;
    }

    public override void bulkInsert(List<SObject> newList){
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newList){
            acn__Sprint__c newSprint = (acn__Sprint__c) newRecord;
            if (!sprintByProjectMap.containsKey(newSprint.acn__Project__c)){
                projectIds.add(newSprint.acn__Project__c);
            }
        }
        getProjectsSprintsData(projectIds);
    }

    public override void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
        Set<Id> projectIds = new Set<Id>();
        for (SObject newRecord : newMap.values()){
            acn__Sprint__c newSprint = (acn__Sprint__c) newRecord;
            acn__Sprint__c oldSprint = (acn__Sprint__c) oldMap.get(newSprint.Id);
            if (!sprintByProjectMap.containsKey(newSprint.acn__Project__c)){
                projectIds.add(newSprint.acn__Project__c);
            }
            if (!sprintByProjectMap.containsKey(oldSprint.acn__Project__c)){
                projectIds.add(oldSprint.acn__Project__c);
            }
        }
        getProjectsSprintsData(projectIds);
    }

    public override void beforeInsert( SObject newRecord){
        acn__Sprint__c newSprint = (acn__Sprint__c) newRecord;
        List<acn__Sprint__c> projectSprints = sprintByProjectMap.get(newSprint.acn__Project__c);
        SprintTriggerHelper.validateSprintStatus(newSprint, null, projectSprints);
    }

    public override void beforeupdate( SObject newRecord,SObject oldRecord ){
        acn__Sprint__c newSprint = (acn__Sprint__c) newRecord; //casting
        acn__Sprint__c oldSprint = (acn__Sprint__c) oldRecord;
        List<acn__Sprint__c> projectSprints = sprintByProjectMap.get(newSprint.acn__Project__c);
        SprintTriggerHelper.validateSprintStatus(newSprint, oldSprint, projectSprints);
        SprintTriggerHelper.setEndDate(newSprint, oldSprint);
    }

    public void getProjectsSprintsData(Set<Id> projectIds){
        if (projectIds.size() > 0){
            Set<Id> tmpIds = CollectionUtils.mergeSet(projectIds, sprintByProjectMap.keySet());
            sprintMap = new Map<Id, acn__Sprint__c>([Select id, acn__Status__c, acn__Project__c
                                                     from acn__Sprint__c
                                                     where acn__Project__c in:tmpIds]);

            sprintByProjectMap = new Map<Id, List<acn__Sprint__c>>(); // se reinicializa fuera del for porque la vamos a usar fuera del for.
            for (acn__Sprint__c sprint : sprintMap.values()){
                if (!sprintByProjectMap.containsKey(sprint.acn__Project__c)){
                    sprintByProjectMap.put(sprint.acn__Project__c, new List<acn__Sprint__c>());
                }
                sprintByProjectMap.get(sprint.acn__Project__c).add(sprint);
            }

        }
    }

}