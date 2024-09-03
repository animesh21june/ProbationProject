public with sharing class goalManager {
    //Employeelist 
    @AuraEnabled(cacheable=true)
    public static List<Employee__c> getEmployee(String searchText) {
        
            if (String.isEmpty(searchText)) {
                //return [SELECT Id, Name FROM Employee__c];
                 return new List<Employee__c>();
               
            } else {
               searchText = '%' + searchText + '%';
                return [SELECT Id, Name FROM Employee__c WHERE Name LIKE :searchText];
             
            }
        
    }
    //Goallist
    @AuraEnabled(cacheable=true)
    public static List<Goal_c__c> getGoal(Id goalId) {
        
            if (goalId !=null) {
                return [SELECT Id, Name,Status__c FROM Goal_c__c WHERE Employee__c =:goalId];
            } else {
                // empty list
                return new List<Goal_c__c>();
            }
        
    }
    //Deleting goal id

    @AuraEnabled
    public static void deleteGoal(Id goalId) {
        
            delete [SELECT Id FROM Goal_c__c WHERE Id = :goalId];
    
    }

}
