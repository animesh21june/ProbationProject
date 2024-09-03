@isTest
public with sharing class GoalTriggerHandlerTest {
    @testSetup
    static void testData() {
        List<Employee__c> employeeList = new List<Employee__c>();
        for (Integer i = 0; i < 5; i++) {
            employeeList.add(new Employee__c(Name = 'Employee ' + i,Goal_Status__c='Still in progress'));
        }
        insert employeeList;
        
        // Create Goal records
        List<Goal_c__c> goalList = new List<Goal_c__c>();
        for (Integer i = 0; i < 5; i++) {
            goalList.add(new Goal_c__c(
                Name = 'Goal ' + i,
                Status__c = 'In Progress', // Initial status
                Employee__c = employeeList[i].Id
            ));
        }
        insert goalList; 
        for (Goal_c__c goal : goalList) {
            goal.Status__c = 'Completed';
        }
        update goalList;
}
@isTest
static void testUpdateGoalStatus() {
    List<Goal_c__c> goalList = [SELECT Id, Status__c, Employee__c FROM Goal_c__c WHERE Status__c = 'In Progress'];
    Map<Id, Goal_c__c> oldGoalMap = new Map<Id, Goal_c__c>([SELECT Id, Status__c FROM Goal_c__c WHERE Id IN :goalList]);

    // Step 2: Update Goals to 'Completed'
    for (Goal_c__c goal : goalList) {
        goal.Status__c = 'Completed';
    }
    update goalList;
    

    Test.startTest();
    GoalTriggerHandler.updateGoalStatus(goalList, oldGoalMap);
    Test.stopTest();

    List<Employee__c> updatedEmployees = [SELECT Id, Goal_Status__c FROM Employee__c];
   for (Employee__c emp : updatedEmployees) {
    Assert.areEqual('Goal Achieved', emp.Goal_Status__c);
   }
}
}