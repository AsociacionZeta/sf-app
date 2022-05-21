public without sharing class ProjectTriggerHandler extends TriggerHandler {

    private static ProjectTriggerHandler singleton;
    public static Boolean allowModifyIssueCount = false;

    public ProjectTriggerHandler() {

    }

    public  static ProjectTriggerHandler getInstance() {

        if(singleton == null){
            singleton = new ProjectTriggerHandler();
        }
        return singleton;
    }


    public override void beforeInsert (SObject newRecord){
        acn__Project__c newProject = (acn__Project__c) newRecord;
        ProjectTriggerHelper.setDefaultValues(newProject);
        ProjectTriggerHelper.setFieldToUpper(newProject);

    }

    public override void  beforeUpdate (SObject newRecord, SObject oldRecord){
        acn__Project__c newProject = (acn__Project__c) newRecord;
        acn__Project__c oldProject = (acn__Project__c) oldRecord;
        ProjectTriggerHelper.setFieldToUpper(newProject);
        ProjectTriggerHelper.restrictModifyIssuesCount(newProject, oldProject);
    }
    
}

    

