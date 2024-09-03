@isTest
public with sharing class managerReviewTest {
    @testSetup
    static void setupTestData() {
        List<Manager__c> managers = new List<Manager__c>();
        managers.add(new Manager__c(Name = 'Test 1'));
        managers.add(new Manager__c(Name = 'Test 2'));
        insert managers;
        
        // Create and insert Employee__c records
        List<Employee__c> employees = new List<Employee__c>();
        Employee__c emp1 = new Employee__c(Name = 'Employee One', Manager__c = managers[0].Id, Department__c = 'Sales');
        Employee__c emp2 = new Employee__c(Name = 'Employee Two', Manager__c = managers[0].Id, Department__c = 'Marketing');
        Employee__c emp3 = new Employee__c(Name = 'Employee Three', Manager__c = managers[1].Id, Department__c = 'HR');
        employees.add(emp1);
        employees.add(emp2);
        employees.add(emp3);
        insert employees;
    }

    @isTest
    static void testGetManagers() {
        Test.startTest();
        
        List<Manager__c> managers = managerReview.getManagers();
        
        // Verify that the managers are returned
        Assert.areNotEqual(null, managers);
        Assert.areEqual(2, managers.size());
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetEmployees() {
        Test.startTest();
        
        // Get Manager IDs
        List<Manager__c> manlist = [SELECT Id FROM Manager__c];
        Id managerOneId = manlist[0].Id;
        Id managerTwoId = manlist[1].Id;
        
        // Test getting employees for a manager with employees
        List<Employee__c> employees = managerReview.getEmployees(managerOneId);
        Assert.areNotEqual(null, employees);
        Assert.areEqual(2, employees.size());
        
        // Test getting employees for a manager with no employees
        employees = managerReview.getEmployees(managerTwoId);
        Assert.areNotEqual(null, employees);
        Assert.areEqual(1, employees.size());
        
        // Test getting employees for a non-existing manager ID
        employees = managerReview.getEmployees(null);
        Assert.areEqual(0, employees.size());
        
        Test.stopTest();
    }
}
