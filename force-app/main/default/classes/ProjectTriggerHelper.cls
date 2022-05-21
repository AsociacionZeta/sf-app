public with sharing class ProjectTriggerHelper {
    
    public static void setFieldToUpper (acn__Project__c newProject) {
        if (newProject.acn__Code__c != null) {
            newProject.acn__Code__c = newProject.acn__Code__c.toUpperCase();
            
        }
    }
    public static void setDefaultValues (acn__Project__c newProject){
        newProject.acn__IssuesCount__c = 0;
    }

    public static void restrictModifyIssuesCount (acn__Project__c newProject, acn__Project__c oldProject){
        if (!ProjectTriggerHandler.allowModifyIssueCount) {
            if (newProject.acn__IssuesCount__c != oldProject.acn__IssuesCount__c) {

                newProject.addError(Label.ModifyProjectIssuesCountError);                
            }            
        }
    }
}
