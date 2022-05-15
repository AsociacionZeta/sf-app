public with sharing class SObjectFieldDescribe {
    @AuraEnabled
    public String apiName { get; set; }

    @AuraEnabled
    public Boolean calculated { get; set; }

    @AuraEnabled
    public Boolean compound { get; set; }

    @AuraEnabled
    public String compoundComponentName { get; set; }

    @AuraEnabled
    public String compoundFieldName { get; set; }

    @AuraEnabled
    public String controllerName { get; set; }

    @AuraEnabled
    public List<String> controllingFields { get; set; }

    @AuraEnabled
    public Boolean createable { get; set; }

    @AuraEnabled
    public Boolean custom { get; set; }

    @AuraEnabled
    public String dataType { get; set; }

    @AuraEnabled
    public String extraTypeInfo { get; set; }

    @AuraEnabled
    public Boolean filterable { get; set; }

    @AuraEnabled
    public SObjectFieldLookupDescribe filteredLookupInfo { get; set; }

    @AuraEnabled
    public Boolean highScaleNumber { get; set; }

    @AuraEnabled
    public Boolean htmlFormatted { get; set; }

    @AuraEnabled
    public String inlineHelpText { get; set; }

    @AuraEnabled
    public String label { get; set; }

    @AuraEnabled
    public Integer length { get; set; }

    @AuraEnabled
    public Boolean nameField { get; set; }

    @AuraEnabled
    public Boolean polymorphicForeignKey { get; set; }

    @AuraEnabled
    public Integer precision { get; set; }

    @AuraEnabled
    public Boolean reference { get; set; }

    @AuraEnabled
    public String referenceTargetField { get; set; }

    @AuraEnabled
    public List<SObjectFieldReferenceToDescribe> referenceToInfos { get; set; }

    @AuraEnabled
    public String relationshipName { get; set; }

    @AuraEnabled
    public Boolean required { get; set; }

    @AuraEnabled
    public Boolean searchPrefilterable { get; set; }

    @AuraEnabled
    public Integer scale { get; set; }

    @AuraEnabled
    public Boolean sortable { get; set; }

    @AuraEnabled
    public Boolean unique { get; set; }

    @AuraEnabled
    public Boolean updateable { get; set; }

}