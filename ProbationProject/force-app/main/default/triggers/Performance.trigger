trigger Performance on Performance_Review__c (before insert,before update,before delete, after insert,after update,after delete,after undelete) {
    
        if(Trigger.isAfter){
            if(Trigger.isInsert || Trigger.isUpdate|| Trigger.isUndelete){
           PerformanceHandler.popluateAvgRating(Trigger.new);
           }
           if(Trigger.isDelete ){
            PerformanceHandler.popluateAvgRating(Trigger.old);
           }
      }
}