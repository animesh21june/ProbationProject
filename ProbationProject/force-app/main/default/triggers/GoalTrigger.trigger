trigger GoalTrigger on Goal_c__c (before insert,before update,before delete, after insert,after update,after delete,after undelete) {
    //calling method for Update 
    if(Trigger.isUpdate){
         if(Trigger.isAfter){
                GoalTriggerHandler.updateGoalStatus(Trigger.new,Trigger.oldMap);
            }
       }
       //calling method for Insert
        else if (Trigger.isAfter){
        if(Trigger.isInsert){
            GoalTriggerHandler.updateGoalStatus(Trigger.new,Trigger.newMap);
        }
       }
}