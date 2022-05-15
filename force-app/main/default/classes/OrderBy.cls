public with sharing class OrderBy {
    @AuraEnabled
    public List<String> fields { get; set; }

    @AuraEnabled
    public String order { get; set; }

}