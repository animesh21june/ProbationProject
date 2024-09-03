import { LightningElement,track,api,wire } from 'lwc';
import getAccounts from '@salesforce/apex/goalManager.getEmployee';
import getGoal from '@salesforce/apex/goalManager.getGoal';
import deleteGoal from '@salesforce/apex/goalManager.deleteGoal';
import { refreshApex } from '@salesforce/apex';


export default class GoalManagement extends LightningElement {
    @track searchEmployee = '';
     employeeId;
     @track isAddGoal=false;
     @track isEditGoal = false;
     @track isDeleteGoal = false;
     @track inputSearch ='';
     @track employeeRecord ;
     isEmpTable= false;
     isGoalTable=false;
    
    handleChange(event){
        this.searchEmployee = event.target.value;
    }
    handleClick() {

        this.isEmpTable = true;
        // Imperatively call the getAccounts method
            console.log('buttom');
            getAccounts({ searchText: this.searchEmployee })
            .then((result) => {
                this.employeeRecord = result;
            })
            .catch((error) => {
                console.error('Error fetching employee records:', error);
            });
        

       
    }
    //Lightning table of Employee Detail
     employeeColumns = [
        {label:'Id',fieldName:'Id'},
        { label: 'Employee Name', fieldName: 'Name' },
        { type: 'button', typeAttributes: { label: 'View Goals', name: 'view_goals', variant: 'brand' } }
    ];
  
    //handling row action of goal 
    handleEmployeeSelect(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.isGoalTable=true;
        if (actionName === 'view_goals') {
            // employee Id whose' s goal data to be render
            console.log('Selected Employee ID: ', row.Id);
            this.employeeId=row.Id;
            

        }
        
    }
   
    goalColumns = [
        {label:'Id',fieldName:'Id'},
        { label: 'Goal Name', fieldName: 'Name' },
        { label: 'Goal status', fieldName: 'Status__c' },

        { type: 'button', typeAttributes: { label: 'EditGoals', name: 'EditGoals', variant: 'brand' } },
        { type: 'button', typeAttributes: { label: 'DeleteGoals', name: 'DeleteGoals', variant: 'brand' } }
    ];
     //geting data goal based on employee
     @wire(getGoal,{goalId:'$employeeId'}) goalRecord;
    //  handleAddGoal(event){
    //     this.isAddGoal=true;
    //     console.log('clicked');
    //  }
     handleAddGoalCancle(event){
        this.isAddGoal=false;
     }
     handleEditGoalCancle(){
       this.isEditGoal = false;
     }
     handleDeleteGoalCancle(){
        this.isDeleteGoal = false;
     }

     //
     goalId;
     handlegoalSelect(event){
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'EditGoals') {
            // employee Id whose' s goal data to be render
            console.log('Selected Employee ID: ', row.Id);
            this.goalId=row.Id;
            //this.isAddGoal=true;
            if (this.goalId) {
                this.isEditGoal = true;
            } else {
                alert('Please select a goal to edit.');
            }
        }
        if (actionName === 'DeleteGoals') {
            // employee Id whose' s goal data to be render
            console.log('Selected Employee ID: ', row.Id);
            this.goalId=row.Id;
            if (this.goalId) {
                       this.isDeleteGoal = true;
                    } else {
                        alert('Please select a goal to delete.');
                    }
        }
     }


     //new 
     handleAddGoal() {
        this.isAddGoal = true;
        this.goalId = null; // Clear goalId for adding new goal
    }

     handleSuccess(event) {
       // this.closeModal();
        // Refresh the goal records
        //return refreshApex(this.goalRecord);
      this.isAddGoal=false;
      this.isEditGoal = false;
      return refreshApex(this.goalRecord);
    }
     

     // Handle delete confirmation
     handleGoalDelete() {
        console.log('delete clicked');
        deleteGoal({ goalId: this.goalId })
            .then(() => {
                this.isDeleteGoal = false;
                // Refresh the goal records
                return refreshApex(this.goalRecord);
              
            })
            .catch(error => {
                console.error('Error deleting goal: ', error);
            });
    }
}