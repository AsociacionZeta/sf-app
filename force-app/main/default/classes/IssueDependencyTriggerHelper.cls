public with sharing class IssueDependencyTriggerHelper {
   
    public static void setUniqueKey (acn__IssueDependency__c newIssueDependency){

        newIssueDependency.acn__UniqueKey__c = newIssueDependency.acn__MainIssue__c + '_' + newIssueDependency.acn__DependantIssue__c;
    }
}
