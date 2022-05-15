public with sharing class SObjectFieldReferenceToDescribe {
    @AuraEnabled
    public String apiName { get; set; }

    @AuraEnabled
    public List<String> nameFields { get; set; }

}