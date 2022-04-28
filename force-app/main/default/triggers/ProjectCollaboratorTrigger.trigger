trigger ProjectCollaboratorTrigger on acn__ProjectCollaborator__c (before insert, before update) {

    ProjectCollaboratorTriggerHandler.getInstance().run(acn__ProjectCollaborator__c.SObjectType);
}