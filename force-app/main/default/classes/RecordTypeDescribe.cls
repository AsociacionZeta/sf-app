public with sharing class RecordTypeDescribe {
    @AuraEnabled
    public Boolean available { get; set; }

    @AuraEnabled
    public Boolean active { get; set; }

    @AuraEnabled
    public Boolean defaultRecordTypeMapping { get; set; }

    @AuraEnabled
    public Boolean master { get; set; }

    @AuraEnabled
    public String name { get; set; }

    @AuraEnabled
    public String devName { get; set; }

    @AuraEnabled
    public String recordTypeId { get; set; }

}