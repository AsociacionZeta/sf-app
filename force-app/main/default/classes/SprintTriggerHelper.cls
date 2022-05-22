public with sharing class SprintTriggerHelper{
    public static void validateSprintStatus(acn__Sprint__c newSprint, acn__Sprint__c oldSprint, List<acn__Sprint__c> projectSprints){

        if (projectSprints == null || projectSprints.size() == 0){
            return;
        }
        if ((oldSprint == null && newSprint.acn__Status__c == 'Active') || (oldSprint != null && newSprint.acn__Status__c == 'Active' && newSprint.acn__Status__c != oldSprint.acn__Status__c)){

            for (acn__Sprint__c sprint : projectSprints){
                if (sprint.acn__Status__c == 'Active'){
                    newSprint.addError(Label.DuplicatedActiveSprintError);
                    break;
                } 
            }
        }
    }

    public static void setEndDate(acn__Sprint__c newSprint, acn__Sprint__c oldSprint){
        if(newSprint.acn__Status__c != oldSprint.acn__Status__c && newSprint.acn__Status__c == 'Done'){
            newSprint.acn__EndDate__c = system.today();
        }
    }

}