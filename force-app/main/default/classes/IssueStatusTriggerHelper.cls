public class IssueStatusTriggerHelper {
    
    public static void validateInitialProject(acn__IssueStatus__c newIssueStatus, acn__IssueStatus__c oldIssueStatus, List<acn__IssueStatus__c> projectIssueStatuses){
        if(projectIssueStatuses == null || projectIssueStatuses.size() == 0)
            return;
        if(newIssueStatus.acn__Active__c && (oldIssueStatus == null || newIssueStatus.acn__Initial__c != oldIssueStatus.acn__Initial__c) && newIssueStatus.acn__Initial__c){
            for(acn__IssueStatus__c status : projectIssueStatuses){
                if(newIssueStatus.Id != status.Id && status.acn__Active__c && newIssueStatus.acn__Initial__c){
                    newIssueStatus.addError(Label.TwoInitialStatusByProjectError);
                    break;
                }
            }
        }
    }

    public static void validateStatusName(acn__IssueStatus__c newIssueStatus, acn__IssueStatus__c oldIssueStatus, List<acn__IssueStatus__c> projectIssueStatuses){
        if(projectIssueStatuses == null || projectIssueStatuses.size() == 0)
            return;
        if(oldIssueStatus == null || newIssueStatus.Name != oldIssueStatus.Name){
            for(acn__IssueStatus__c status : projectIssueStatuses){
                if(newIssueStatus.Id != status.Id && newIssueStatus.Name ==  status.Name){               
                    newIssueStatus.addError(Label.TwoEqualStatusOnProjectError);
                    break;
                }
            }
        }
    }
}
