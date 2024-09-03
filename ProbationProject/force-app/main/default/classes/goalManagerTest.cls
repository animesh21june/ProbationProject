@istest
public with sharing class goalManagerTest {
    @testSetup
    public static void TestData() {
        // Create test data
        List<Employee__c> empList = new List<Employee__c>();
        List<Goal_c__c> goalList = new List<Goal_c__c>();
        //first data
        Employee__c emp1 = new Employee__c(Name = 'John Doe');
        empList.add(emp1);
        //second data 
        Employee__c emp2 = new Employee__c(Name = 'Jane Smith');
        empList.add(emp2);
        insert empList; 
        //goal data
        Goal_c__c goal1 = new Goal_c__c(Name = 'Complete Project', Status__c = 'In Progress', Employee__c = emp1.Id);
        goalList.add(goal1);
        Goal_c__c goal2 = new Goal_c__c(Name = 'Training', Status__c = 'Completed', Employee__c = emp1.Id);
        goalList.add(goal2);
        Goal_c__c goal3 = new Goal_c__c(Name = 'Attend Conference', Status__c = 'Not Started', Employee__c = emp2.Id);
        goalList.add(goal3);
        insert goalList;
    }
    
    @isTest
   public  static void testGetEmployee() {
        Test.startTest();
        
        // Test search with empty string
        List<Employee__c> employees = goalManager.getEmployee('');
        Assert.areEqual(0, employees.size());
        
        // Test search with a name that exists
        employees = goalManager.getEmployee('John');
        Assert.areEqual(1, employees.size());
        Assert.areEqual('John Doe', employees[0].Name);
        
        // Test search with a name that doesn't exist
        employees = goalManager.getEmployee('Not exist');
        Assert.areEqual(0, employees.size());
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetGoal() {
        Test.startTest();
        
        // Get Employee ID
        Employee__c emp = [SELECT Id FROM Employee__c WHERE Name = 'John Doe' LIMIT 1];
        
        // Test getting goals for an existing employee
        List<Goal_c__c> goals = goalManager.getGoal(emp.Id);
        Assert.areEqual(2, goals.size());
        
        // Test getting goals for an employee with no goals
        Employee__c empNoGoal = [SELECT Id FROM Employee__c WHERE Name = 'Jane Smith' LIMIT 1];
        goals = goalManager.getGoal(empNoGoal.Id);
        Assert.areEqual(1, goals.size());
        
        // Test getting goals for a non-existing employee ID
        goals = goalManager.getGoal(null);
        Assert.areEqual(0, goals.size());
        
        Test.stopTest();
    }
    
    @isTest
    public static void testDeleteGoal() {
        Test.startTest();
        
        // Get a goal to delete
        Goal_c__c goalToDelete = [SELECT Id FROM Goal_c__c LIMIT 1];
        
        // Delete the goal
        goalManager.deleteGoal(goalToDelete.Id);
        
        // Verify goal is deleted
        // Perform a SOQL query to check if the goal still exists
        List<Goal_c__c> deletedGoals = [SELECT Id FROM Goal_c__c WHERE Id = :goalToDelete.Id LIMIT 1];
        Assert.areEqual(0, deletedGoals.size(), 'Goal should be deleted');
        
        Test.stopTest();
}
}