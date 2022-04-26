public with sharing class ProjectCollaboratorTriggerHelper {
    
    public static void setUniqueKey (acn__ProjectCollaborator__c newProjectCollaborator){
        newProjectCollaborator.acn__Unique_Key__c = acn__ProjectCollaborator__c.acn__Project__c + '-' + acn__ProjectCollaborator__c.acn__Contact__c;
    }
}
