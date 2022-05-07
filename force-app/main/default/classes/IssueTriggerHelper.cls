public with sharing class IssueTriggerHelper {
    
    public static void setIssueName(acn__Issue__c newIssue, acn__Project__c project){
        Integer issueNumber = getIssueNumber(project);
        String issueNumberStr = String.valueOf((issueNumber + 1));
        newIssue.Name = project.acn__Code__c + '-' + issueNumberStr.leftPad(5, '0');
    }

    public static void incrementIssueCount(acn__Project__c project){
        Integer issueNumber = getIssueNumber(project);
        project.acn__IssuesCount__c = issueNumber + 1;
    }

    public static void decrementIssueCount(acn__Project__c project){
        Integer issueNumber = getIssueNumber(project);
        project.acn__IssuesCount__c = issueNumber - 1;
    }



    private static Integer getIssueNumber(acn__Project__c project){
        return (project.acn__IssuesCount__c != null) ? project.acn__IssuesCount__c.intValue() : 0;
    }

    public static void validateIssueAssigment(acn__Issue__c newIssue, Set<Id> projectCollaboratorsContactIds){
        if(projectCollaboratorsContactIds == null || projectCollaboratorsContactIds.size() == 0 ){
            newIssue.addError(Label.IssueContactAssignError);
        } else if (!projectCollaboratorsContactIds.contains(newIssue.acn__AssignedTo__c)){
            newIssue.addError(Label.IssueContactAssignError);
        }
     }

}
