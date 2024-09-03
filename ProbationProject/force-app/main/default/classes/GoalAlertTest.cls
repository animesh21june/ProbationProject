@isTest
public with sharing class GoalAlertTest {
    @testSetup
    static void setupTestData() {
        // Create and insert Manager__c records
        Manager__c manager1 = new Manager__c(Name = 'Manager One', Email__c = 'manager1@example.com');
        Manager__c manager2 = new Manager__c(Name = 'Manager Two', Email__c = 'manager2@example.com');
        insert new List<Manager__c>{manager1, manager2};

        // Create and insert Employee__c records
        Employee__c emp1 = new Employee__c(Name = 'Employee One', Email__c = 'employee1@example.com', Manager__c = manager1.Id);
        Employee__c emp2 = new Employee__c(Name = 'Employee Three', Email__c = 'employee3@example.com', Manager__c = manager2.Id);
        insert new List<Employee__c>{emp1, emp2};

        // Create and insert Goal_c__c records
        Goal_c__c goal1 = new Goal_c__c(Name = 'Goal One', Target_Date__c = Date.today().addDays(-1), Status__c = 'Not Started', Employee__c = emp1.Id);
        Goal_c__c goal2 = new Goal_c__c(Name = 'Goal Two', Target_Date__c = Date.today().addDays(-1), Status__c = 'Completed', Employee__c = emp2.Id);
        insert new List<Goal_c__c>{goal1, goal2};
    }
    @isTest
    static void testSendAlert() {
        Test.startTest();
        
        // Get the goals that should trigger the alert
        List<Goal_c__c> goalsToTest = [SELECT Id, Employee__c, Target_Date__c, Status__c FROM Goal_c__c];
        
        // Call the sendAlert method
        GoalAlertHandler.sendAlert(goalsToTest, new Map<Id, Goal_c__c>());
        
        Test.stopTest();
    }
    
    @isTest
    static void testSendAlertNoGoals() {
        Test.startTest();
        
        // Call the sendAlert method with an empty list of goals
        GoalAlertHandler.sendAlert(new List<Goal_c__c>(), new Map<Id, Goal_c__c>());
        
        Test.stopTest();
    }
}