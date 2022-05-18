public with sharing class ChildRelationshipDescribe {
    @AuraEnabled
    public String childObjectApiName { get; set; }

    @AuraEnabled
    public String fieldName { get; set; }

    @AuraEnabled
    public List<String> junctionIdListNames { get; set; }

    @AuraEnabled
    public List<String> junctionReferenceTo { get; set; }

    @AuraEnabled
    public String relationshipName { get; set; }

}