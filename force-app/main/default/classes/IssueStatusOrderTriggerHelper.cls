public with sharing class IssueStatusOrderTriggerHelper {
    
    public static void setUniqueKey(acn__IssueStatusOrder__c newIssueStatusOrder){
        newIssueStatusOrder.acn__UniqueKey__c = newIssueStatusOrder.acn__Status__c + '_' + newIssueStatusOrder.acn__ChangeTo__c;
    }

    public static void setName(acn__IssueStatusOrder__c newIssueStatusOrder, acn__IssueStatus__c status, acn__IssueStatus__c changeTo){
        newIssueStatusOrder.Name = status.Name + ' to ' + changeTo.Name;
    }

    public static void retrictModifyName(acn__IssueStatusOrder__c newIssueStatusOrder, acn__IssueStatusOrder__c oldIssueStatusOrder){
        if(newIssueStatusOrder.Name != oldIssueStatusOrder.Name){
            newIssueStatusOrder.addError(Label.NameFieldIsNotEditable);
        }
    }

    public static void validateStatusAndChangeToProject(acn__IssueStatusOrder__c newIssueStatusOrder, acn__IssueStatus__c status, acn__IssueStatus__c changeTo){
        if(status != null && changeTo != null && status.acn__Project__c != changeTo.acn__Project__c){
            newIssueStatusOrder.addError(Label.StatusAndChangeToProjectError);
        }
    }

}
