public class SObjectDescribe {
    @AuraEnabled
    public String apiName { get; set; }

    @AuraEnabled
    public String associateEntityType { get; set; }

    @AuraEnabled
    public String associateParentEntity { get; set; }

    @AuraEnabled
    public List<ChildRelationshipDescribe> childRelationships { get; set; }

    @AuraEnabled
    public Boolean createable { get; set; }

    @AuraEnabled
    public Boolean custom { get; set; }

    @AuraEnabled
    public String defaultRecordTypeId { get; set; }

    @AuraEnabled
    public Boolean deletable { get; set; }

    @AuraEnabled
    public Map<String, Object> dependentFields { get; set; }

    @AuraEnabled
    public Boolean feedEnabled { get; set; }

    @AuraEnabled
    public Map<String, SObjectFieldDescribe> fields { get; set; }

    @AuraEnabled
    public String keyPrefix { get; set; }

    @AuraEnabled
    public String label { get; set; }

    @AuraEnabled
    public String labelPlural { get; set; }

    @AuraEnabled
    public Boolean layoutable { get; set; }

    @AuraEnabled
    public Boolean mruEnabled { get; set; }

    @AuraEnabled
    public List<String> nameFields { get; set; }

    @AuraEnabled
    public Boolean queryable { get; set; }

    @AuraEnabled
    public Map<String, RecordTypeDescribe> recordTypeInfos { get; set; }

    @AuraEnabled
    public Boolean searchable { get; set; }

    @AuraEnabled
    public SObjectThemeInfo themeInfo { get; set; }

    @AuraEnabled
    public Boolean updateable { get; set; }

}