public with sharing class ProjectTriggerHelper {
    
    public static void setFieldToUpper (acn__Project__c newProject) {
        if (newProject.acn__Code__c != null) {
            newProject.acn__Code__c = newProject.acn__Code__c.toUpperCase();
            
        }
    }
}
