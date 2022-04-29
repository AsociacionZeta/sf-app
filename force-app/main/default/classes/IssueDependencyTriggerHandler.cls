public without sharing class IssueDependencyTriggerHandler extends TriggerHandler {

    private static IssueDependencyTriggerHandler singleton;

    private IssueDependencyTriggerHandler() {
    }

    public static IssueDependencyTriggerHandler getInstance(){
        if(singleton == null){
            singleton = new IssueDependencyTriggerHandler ();
        }
        return singleton;
    }

    public override void beforeInsert(SObject newRecord){
        acn__IssueDependency__c newIssueDependency = (acn__IssueDependency__c) newRecord;
        IssueDependencyTriggerHelper.setUniqueKey(newIssueDependency);
    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord){
        acn__IssueDependency__c newIssueDependency = (acn__IssueDependency__c) newRecord;
        acn__IssueDependency__c oldIssueDependency = (acn__IssueDependency__c) oldRecord;
        IssueDependencyTriggerHelper.setUniqueKey(newIssueDependency);
    }
}
