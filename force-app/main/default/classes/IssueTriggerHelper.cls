public with sharing class IssueTriggerHelper {
    public static void setIssueName(acn__Issue__c newIssue, acn__Project__c project) {
        Integer issueNumber = getIssueNumber(project);
        String issueNumberStr = String.valueOf((issueNumber + 1));
        newIssue.Name = project.acn__Code__c + '-' + issueNumberStr.leftPad(5, '0');
    }

    public static void incrementIssueCount(acn__Project__c project) {
        Integer issueNumber = getIssueNumber(project);
        project.acn__IssuesCount__c = issueNumber + 1;
    }

    public static void decrementIssueCount(acn__Project__c project) {
        Integer issueNumber = getIssueNumber(project);
        project.acn__IssuesCount__c = issueNumber - 1;
    }

    private static Integer getIssueNumber(acn__Project__c project) {
        return (project.acn__IssuesCount__c != null) ? project.acn__IssuesCount__c.intValue() : 0;
    }

    public static void validateIssueAssigment(acn__Issue__c newIssue, Set<Id> projectCollaboratorsContactIds) {
        if (projectCollaboratorsContactIds == null || projectCollaboratorsContactIds.size() == 0) {
            newIssue.addError(Label.IssueContactAssignError);
        } else if (!projectCollaboratorsContactIds.contains(newIssue.acn__AssignedTo__c)) {
            newIssue.addError(Label.IssueContactAssignError);
        }
    }

    public static void validateIssueOpenedBy(acn__Issue__c newIssue, Set<Id> projectCollaboratorsContactIds) {
        if (projectCollaboratorsContactIds == null || projectCollaboratorsContactIds.size() == 0) {
            newIssue.addError(Label.IssueOpenedByError);
        } else if (!projectCollaboratorsContactIds.contains(newIssue.acn__OpenedBy__c)) {
            newIssue.addError(Label.IssueOpenedByError);
        }
    }

    public static void preventChangeOpenedBy(acn__Issue__c newIssue, acn__Issue__c oldIssue) {
        if (newIssue.acn__OpenedBy__c != oldIssue.acn__OpenedBy__c) {
            newIssue.addError(Label.IssueChangeOpenedByError);
        }
    }

    public static void setInitialStatus(acn__Issue__c newIssue, acn__IssueStatus__c initialStatus) {
        if (initialStatus != null) {
            newIssue.acn__Status__c = initialStatus.Id;
        } else {
            newIssue.addError(Label.NotActiveInitialStatusError);
        }
    }

    public static void validateStatus(acn__Issue__c newIssue, acn__Issue__c oldIssue, Map<Id, acn__IssueStatus__c> statusFromProject, Set<Id> changeToStatuses) {
        if (newIssue.acn__Status__c != oldIssue.acn__Status__c && statusFromProject != null) {
            acn__IssueStatus__c newStatus = statusFromProject.get(newIssue.acn__Status__c);
            if (newStatus == null) {
                newIssue.addError(Label.IssueStatusNotbelongToProjectError);
            } else if (!newStatus.Active__c) {
                newIssue.addError(Label.IssueStatusIsNotActiveError);
            } else if (changeToStatuses == null) {
                newIssue.addError(Label.NotStatusOrderSetError);
            } else if (!changeToStatuses.contains(newIssue.acn__Status__c)) {
                newIssue.addError(Label.WrongAssignedStatusError);
            }
        }
    }

    public static void assingIssue(acn__Issue__c newIssue, acn__Issue__c oldIssue, Map<Id, acn__IssueStatusOrder__c> orderByChangeTo) {
        if (newIssue.acn__Status__c != oldIssue.acn__Status__c) {
            acn__IssueStatusOrder__c order = orderByChangeTo.get(newIssue.acn__Status__c);
            if(order != null){
                if (order.acn__AssignTo__c != null) {
                    newIssue.acn__AssignedTo__c = order.acn__AssignTo__c;
                } else if(order.acn__ToLastAssignment__c && newIssue.acn__PreviousAssignment__c != null){
                    newIssue.acn__AssignedTo__c = newIssue.acn__PreviousAssignment__c;
                }
            }
        }
    }

    public static void setPreviousAssignment(acn__Issue__c newIssue, acn__Issue__c oldIssue) {
        if (newIssue.acn__AssignedTo__c != oldIssue.acn__AssignedTo__c) {
            newIssue.acn__PreviousAssignment__c = oldIssue.acn__AssignedTo__c;
        }
    }

}