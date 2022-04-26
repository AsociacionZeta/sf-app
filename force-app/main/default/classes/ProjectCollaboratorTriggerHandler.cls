public without sharing class ProjectCollaboratorTriggerHandler extends TriggerHandler{
    private static ProjectCollaboratorTriggerHandler singleton;

    private ProjectCollaboratorTriggerHandler(){
    }

    public static ProjectCollaboratorTriggerHandler getInstance(){
        if (singleton == null){
            singleton = new ProjectCollaboratorTriggerHandler();
        }
        return singleton;
    }

    public override void beforeInsert(SObject newRecord){
        acn__ProjectCollaborator__c newProjectCollaborator = (acn__ProjectCollaborator__c) newRecord;
        ProjectCollaboratorTriggerHelper.setUniqueKey(newProjectCollaborator);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord){
        acn__ProjectCollaborator__c newProjectCollaborator = (acn__ProjectCollaborator__c) newRecord;
        acn__ProjectCollaborator__c oldProjectCollaborator = (acn__ProjectCollaborator__c) oldRecord;
        if (newProjectCollaborator.acn__Project__c != oldProjectCollaborator.acn__Project__c || newProjectCollaborator.acn__Contact__c != oldProjectCollaborator.acn__Contact__c){
            ProjectCollaboratorTriggerHelper.setUniqueKey(newProjectCollaborator);
        }
    }

}