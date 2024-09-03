public with sharing class PerformanceHandler {
    public static void popluateAvgRating(List<Performance_Review__c> pRlist){
        Set<Id> empIdToUpdate = new Set<Id>();
        for(Performance_Review__c pR:pRlist){
            empIdToUpdate.add(pR.Employee__c);
        }
        AggregateResult[] avgRatingList =[SELECT AVG(Rating__c)Avg,Employee__c FROM Performance_Review__c GROUP   BY Employee__c];
        Map<Id,Decimal> avgMap = new Map<Id,Decimal>();
        for(AggregateResult avgRating:avgRatingList ){
            Id  empId = (Id)avgRating.get('Employee__c');
            Decimal rating= (Decimal)avgRating.get('Avg');
            avgMap.put(empId,rating);
        }
        List<Employee__c> emplist = [Select Id,Average_Rating__c From Employee__c where Id In:empIdToUpdate];
        for(Employee__c emp:emplist){
            if(avgMap.containsKey(emp.Id)){
                emp.Average_Rating__c = avgMap.get(emp.Id);
            }
        }
         //update
         if(!empList.isEmpty()) {
            update empList;
        }
    }
}