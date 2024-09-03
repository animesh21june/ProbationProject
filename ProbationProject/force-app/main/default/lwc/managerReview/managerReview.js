import { LightningElement, track, wire } from 'lwc';
import getManagers from '@salesforce/apex/managerReview.getManagers';
import getEmployees from '@salesforce/apex/managerReview.getEmployees';

export default class ManagerReview extends LightningElement {
    @track managerData = [];
    @track selectedManagerId = '';
    @track employeeData = [];
    @track isEmployeeTableVisible = false;
    @track selectedEmployee = {};
    @track selectedEmployeeId;
    @track isEmployeeDetailModalVisible = false;
    @track isPerformanceReviewModalVisible = false;
    


     // Manager Datatable Columns
     managerColumns = [
        { label: 'Manager Name', fieldName: 'Name' },
        { type: 'button', typeAttributes: { label: 'View Employees', name: 'view_employees', variant: 'brand' } }
    ];
     // Fetch managers on load
     @wire(getManagers)
     wiredManagers({ data, error }) {
         if (data) {
             this.managerData = data;
         } else if (error) {
             console.error(error);
         }
     }
    
       // Employee Datatable Columns
    employeeColumns = [
        { label: 'Employee Name', fieldName: 'Name' },
        { label: 'GoalStatus', fieldName: 'Goal_Status__c' },
        { label: 'Department', fieldName: 'Department__c' },
        { type: 'button', typeAttributes: { label: 'View Details', name: 'view_details', variant: 'brand' } }
    ];

     // Handle Manager Selection
     handleManagerSelect(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'view_employees') {
            this.selectedManagerId = row.Id;
            this.isEmployeeTableVisible = true;

            // Fetch Employees under selected Manager
            getEmployees({ managerId: this.selectedManagerId })
                .then(result => {
                    this.employeeData = result;
                })
                .catch(error => {
                    console.error(error);
                });
        }
    }
    // Handle Employee Selection
    handleEmployeeSelect(event) {
        const actionName = event.detail.action.name;
        this.selectedEmployeeId = event.detail.row.Id;
        const row = event.detail.row;

        if (actionName === 'view_details') {
            this.selectedEmployee = row;
            this.isEmployeeDetailModalVisible = true;
        }
    }
    //Cancel Employee detail modal popup // Animesh
    cancelEmployeeModal(){
        this.isEmployeeDetailModalVisible = false;
    }
     // Open Performance Review Modal
     openPerformanceReviewModal() {
        this.isEmployeeDetailModalVisible = false;
        this.isPerformanceReviewModalVisible = true;
    }

    // Close Performance Review Modal
    closePerformanceReviewModal() {
        this.isPerformanceReviewModalVisible = false;
    }
    handleReviewSuccess(){
        this.isPerformanceReviewModalVisible = false;
    }
}