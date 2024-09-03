public with sharing class employeeDashboard {
    public employeeDashboard() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployees(String searchText) {
        String searchPattern = '%' + searchText + '%';
        return [SELECT Id, Name FROM Employee__c WHERE Name LIKE :searchPattern];
    }

    @AuraEnabled(cacheable=true)
    public static List<Goal_c__c> getEmployeeGoals(Id employeeId) {
        return [SELECT Id, Name, Status__c FROM Goal_c__c WHERE Employee__c = :employeeId];
    }

    @AuraEnabled(cacheable=true)
    public static List<Skill_Assessment__c> getEmployeeSkills(Id employeeId) {
        return [SELECT Id, Name, Proficiency_Level__c FROM Skill_Assessment__c WHERE Employee__c = :employeeId];
    }

    @AuraEnabled(cacheable=true)
    public static Decimal getEmployeeAverageRating(Id employeeId) {
        Employee__c employee = [SELECT Average_Rating__c FROM Employee__c WHERE Id = :employeeId LIMIT 1];
        return employee.Average_Rating__c;
    }
}

