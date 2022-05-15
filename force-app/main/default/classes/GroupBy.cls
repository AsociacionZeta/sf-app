public with sharing class GroupBy {
    @AuraEnabled
    public List<String> fields { get; set; }

    @AuraEnabled
    public List<WhereCondition> havingCoditions { get; set; }

    @AuraEnabled
    public String customLogic { get; set; }

}