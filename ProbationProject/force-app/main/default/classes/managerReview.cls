public with sharing class managerReview {
    
    @AuraEnabled(cacheable=true)
    public static List<Manager__c> getManagers() {
        return [SELECT Id, Name FROM Manager__c];
    }

    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployees(Id managerId) {
        return [SELECT Id, Name, Goal_Status__c, Department__c FROM Employee__c WHERE Manager__c = :managerId];
    }
}