@istest
public with sharing class performanceHandlerTest {
    @testSetup
    static void testData() {
        // Create and insert Employee__c records
        Employee__c emp1 = new Employee__c(Name = 'Employee One');
        Employee__c emp2 = new Employee__c(Name = 'Employee Two');
        insert new List<Employee__c>{emp1, emp2};

        // Create and insert Performance_Review__c records
        Performance_Review__c pR1 = new Performance_Review__c(Employee__c = emp1.Id, Rating__c = 4);
        Performance_Review__c pR2 = new Performance_Review__c(Employee__c = emp1.Id, Rating__c = 5);
        Performance_Review__c pR3 = new Performance_Review__c(Employee__c = emp2.Id, Rating__c = 3);
        Performance_Review__c pR4 = new Performance_Review__c(Employee__c = emp2.Id, Rating__c = 2);
        insert new List<Performance_Review__c>{pR1, pR2, pR3, pR4};
    }

    @isTest
    static void testPopulateAvgRating() {
        // Performance_Review__c records 
        List<Performance_Review__c> performanceReviewList = [SELECT Id, Employee__c, Rating__c FROM Performance_Review__c];

        Test.startTest();
        PerformanceHandler.popluateAvgRating(performanceReviewList);
        Test.stopTest();

        Employee__c emp1 = [SELECT Id, Average_Rating__c FROM Employee__c WHERE Name = 'Employee One'];
        Assert.areEqual(4.5, emp1.Average_Rating__c);

        Employee__c emp2 = [SELECT Id, Average_Rating__c FROM Employee__c WHERE Name = 'Employee Two'];
        Assert.areEqual(2.5, emp2.Average_Rating__c);
    }

    @isTest
    static void testPopulateAvgRatingWithNoReviews() {
        // Create an employee without any performance reviews
        Employee__c emp3 = new Employee__c(Name = 'Employee Three');
        insert emp3;

        // Call the method with no reviews for this employee
        List<Performance_Review__c> emptyReviewList = new List<Performance_Review__c>();

        Test.startTest();
        PerformanceHandler.popluateAvgRating(emptyReviewList);
        Test.stopTest();

        // Verify that the average rating remains null
        emp3 = [SELECT Id, Average_Rating__c FROM Employee__c WHERE Id = :emp3.Id];
        Assert.areEqual(null, emp3.Average_Rating__c);
    }
}