public with sharing class ProjectCollaboratorTriggerHelper {
    
    public static void setUniqueKey (acn__ProjectCollaborator__c newProjectCollaborator){
        newProjectCollaborator.acn__Unique_Key__c = newProjectCollaborator.acn__Project__c + '-' + newProjectCollaborator.acn__Contact__c;
    }
}