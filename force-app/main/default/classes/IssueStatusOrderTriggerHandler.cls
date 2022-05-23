public without sharing class IssueStatusOrderTriggerHandler extends TriggerHandler {
    private static IssueStatusOrderTriggerHandler singleton;
    private Map<Id, acn__IssueStatus__c> allStatuses = new Map<Id, acn__IssueStatus__c>();
    private IssueStatusOrderTriggerHandler() {
    }

    public static IssueStatusOrderTriggerHandler getInstance() {
        if (singleton == null) {
            singleton = new IssueStatusOrderTriggerHandler();
        }
        return singleton;
    }

    public override void bulkInsert(List<SObject> newList){
        Set<Id> statusIds = new Set<Id>();
        for (SObject newRecord : newList){
            acn__IssueStatusOrder__c newIssueStatusOrder = (acn__IssueStatusOrder__c) newRecord;
            if (!allStatuses.containsKey(newIssueStatusOrder.acn__Status__c)){
                statusIds.add(newIssueStatusOrder.acn__Status__c);
            }
            if (!allStatuses.containsKey(newIssueStatusOrder.acn__ChangeTo__c)){
                statusIds.add(newIssueStatusOrder.acn__ChangeTo__c);
            }
        }
        getStatusData(statusIds);
    }

    public override void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap){
        Set<Id> statusIds = new Set<Id>();
        for (SObject newRecord : newMap.values()){
            acn__IssueStatusOrder__c newIssueStatusOrder = (acn__IssueStatusOrder__c) newRecord;
            acn__IssueStatusOrder__c oldIssueStatusOrder = (acn__IssueStatusOrder__c) oldMap.get(newIssueStatusOrder.Id);
            if (!allStatuses.containsKey(newIssueStatusOrder.acn__Status__c)){
                statusIds.add(newIssueStatusOrder.acn__Status__c);
            }
            if (!allStatuses.containsKey(newIssueStatusOrder.acn__ChangeTo__c)){
                statusIds.add(newIssueStatusOrder.acn__ChangeTo__c);
            }
            if (!allStatuses.containsKey(oldIssueStatusOrder.acn__Status__c)){
                statusIds.add(oldIssueStatusOrder.acn__Status__c);
            }
            if (!allStatuses.containsKey(oldIssueStatusOrder.acn__ChangeTo__c)){
                statusIds.add(oldIssueStatusOrder.acn__ChangeTo__c);
            }
        }
        getStatusData(statusIds);
    }

    public override void beforeInsert(SObject newRecord){
        acn__IssueStatusOrder__c newIssueStatusOrder = (acn__IssueStatusOrder__c) newRecord;
        acn__IssueStatus__c originStatus = allStatuses.get(newIssueStatusOrder.acn__Status__c);
        acn__IssueStatus__c changeToStatus = allStatuses.get(newIssueStatusOrder.acn__ChangeTo__c);
        IssueStatusOrderTriggerHelper.validateStatusAndChangeToProject(newIssueStatusOrder, originStatus, changeToStatus);
        IssueStatusOrderTriggerHelper.setUniqueKey(newIssueStatusOrder);
        IssueStatusOrderTriggerHelper.setName(newIssueStatusOrder, originStatus, changeToStatus);

    }

    public override void beforeUpdate(SObject newRecord, SObject oldRecord){
        acn__IssueStatusOrder__c newIssueStatusOrder = (acn__IssueStatusOrder__c) newRecord;
        acn__IssueStatusOrder__c oldIssueStatusOrder = (acn__IssueStatusOrder__c) oldRecord;
        acn__IssueStatus__c originStatus = allStatuses.get(newIssueStatusOrder.acn__Status__c);
        acn__IssueStatus__c changeToStatus = allStatuses.get(newIssueStatusOrder.acn__ChangeTo__c);
        IssueStatusOrderTriggerHelper.validateStatusAndChangeToProject(newIssueStatusOrder, originStatus, changeToStatus);
        IssueStatusOrderTriggerHelper.retrictModifyName(newIssueStatusOrder, oldIssueStatusOrder);
        IssueStatusOrderTriggerHelper.setUniqueKey(newIssueStatusOrder);
        IssueStatusOrderTriggerHelper.setName(newIssueStatusOrder, originStatus, changeToStatus);
    }

    private void getStatusData(Set<Id> statusIds) {
        if (statusIds.size() > 0) {
            Set<Id> tmpIds = CollectionUtils.mergeSet(statusIds, allStatuses.keySet());
            allStatuses = new Map<Id, acn__IssueStatus__c>([Select Id, Name, acn__Project__c, acn__Active__c
                                                            from acn__IssueStatus__c
                                                            where Id in:tmpIds]);
        }
    }

}