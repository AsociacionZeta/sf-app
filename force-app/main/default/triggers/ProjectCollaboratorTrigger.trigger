trigger ProjectCollaboratorTrigger on acn__ProjectCollaborator__c (before insert, before update) {

    ProjectTriggerHandler.getInstance().run(acn__ProjectCollaborator__c.SObjectType);
}