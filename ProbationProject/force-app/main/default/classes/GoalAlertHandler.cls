public with sharing class GoalAlertHandler {
    //Trigger Method
    public static void sendAlert(List<Goal_c__c> goallist,Map<Id,Goal_c__c> oldgoalMap){
        Set<Id> empId = new Set<Id>();
        for(Goal_c__c gol: goallist){
            if (gol.Target_Date__c < Date.today() && gol.Status__c != 'Completed'){
                empId.add(gol.Employee__c);
            }
        }
        //Sending Notification To Employee
        Set<Id> manId = new Set<Id>();//set to store manager Id 
        List<Employee__c> empList = [SELECT ID,Email__c,Name,Manager__c FROM Employee__c WHERE ID IN:empId];
       // List<Messaging.SingleEmailMessage> employeeEmailList = new <Messaging.SingleEmailMessage>();
        for(Employee__c emp:empList){
            if(emp.Email__c !=null){
                Messaging.SingleEmailMessage employeeEmail = new Messaging.SingleEmailMessage();
                employeeEmail.setToAddresses(new String[] {emp.Email__c});
                employeeEmail.setSubject('Alert Your Target Date is Passed');
                employeeEmail.setPlainTextBody('Dear ' + emp.Name + ',\n\nYour goal target date is passed without being completed. Please take necessary action.\n\nBest regards,\n Management');
                //sending email
                Messaging.sendEmail(new Messaging.Email[] {employeeEmail });
                manId.add(emp.Manager__c);//passing manager id 
            }
           
        }
       //sending email to Manager 
       List<Manager__c> manList = [SELECT ID,Email__c,Name FROM Manager__c WHERE ID IN:manId];
       for(Manager__c man:manList){
        if(man.Email__c!=null){
            Messaging.SingleEmailMessage managerEmail = new Messaging.SingleEmailMessage();
            managerEmail.setToAddresses(new String[] {man.Email__c});
            managerEmail.setSubject('Alert Employee  Goal Target Date Passed');
            managerEmail.setPlainTextBody('Dear ' + man.Name + ',\n\nThe goal  assigned to your team has passed its target date without being completed.\n\nBest regards,\nManagement');
            Messaging.sendEmail(new Messaging.Email[] {managerEmail});
        }
      
       }
        
    }
}