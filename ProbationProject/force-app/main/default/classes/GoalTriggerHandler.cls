public with sharing class GoalTriggerHandler {
    
    //trigger function 
    public static void updateGoalStatus(List<Goal_c__c> goallist,Map<Id,Goal_c__c> oldgoalMap ){
        //set for storing id of goal object whose status is completed 
        Set<Id> empId = new Set<Id>();
        for(Goal_c__c gol:goallist){
            if(gol.Status__c != oldgoalMap.get(gol.Id).Status__c && gol.Status__c =='Completed' || gol.Status__c == 'Completed'){
                empId.add(gol.Employee__c);
            }
        }
        //calling employee record using employee id in set  
        List<Employee__c> empList = [SELECT ID,Goal_Status__c FROM Employee__c WHERE ID IN:empId];
        if(!empList.isEmpty()){
            for(Employee__c emp:empList){
                emp.Goal_Status__c= 'Goal Achieved';
            }
        }
        //updating Employee Object 
        update empList;
    }
}