trigger GoalAlert on Goal_c__c (before insert,before update,before delete, after insert,after update,after delete,after undelete) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
               GoalAlertHandler.sendAlert(Trigger.new,Trigger.oldMap);
           }
      }
}