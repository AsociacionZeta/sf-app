public with sharing class SObjectFieldLookupDescribe {
    @AuraEnabled
    public List<String> controllingFields { get; set; }

    @AuraEnabled
    public Boolean dependent { get; set; }

    @AuraEnabled
    public Boolean optionalFilter { get; set; }

}