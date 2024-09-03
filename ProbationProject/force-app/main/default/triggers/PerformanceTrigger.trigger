trigger PerformanceTrigger on Performance_Review__c (before insert,before update,before delete, after insert,after update,after delete,after undelete) {
    if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){
        if(Trigger.isAfter){
            SkillTriggerHandler.populateAvgRating(Trigger.new);
           }
      }
}