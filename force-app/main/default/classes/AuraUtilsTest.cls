@isTest
public with sharing class AuraUtilsTest {
    
    @isTest
    public static void testAuraException(){
        try {
            Account acc;
            acc.Name = 'Test';
        } catch (Exception e) {
            AuraUtils.AuraException('Test', e, null);
        }
    }

}
