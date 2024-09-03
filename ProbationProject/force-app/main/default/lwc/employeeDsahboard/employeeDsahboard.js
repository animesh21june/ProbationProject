import { LightningElement,track,wire } from 'lwc';
import getEmployees from '@salesforce/apex/employeeDashboard.getEmployees';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';

import CHARTJS from '@salesforce/resourceUrl/ChartJs';

//
import getEmployeeGoals from '@salesforce/apex/employeeDashboard.getEmployeeGoals';
import getEmployeeSkills from '@salesforce/apex/employeeDashboard.getEmployeeSkills';
import getEmployeeAverageRating from '@salesforce/apex/employeeDashboard.getEmployeeAverageRating';
export default class EmployeeDsahboard extends LightningElement {
   
    @track employeeData;
    @track selectedEmployeeId;
    @track isLoading = false;
    @track searchTerm = '';
    chartJsJs;
    employeeColumns = [
        { label: 'Employee Name', fieldName: 'Name', type: 'text' },
        { type: 'button', typeAttributes: { label: 'Select', name: 'select' } }
    ];

    @wire(getEmployees, { searchText: '$searchTerm' })
    wiredEmployees({ data, error }) {
        if (data) {
            this.employeeData = data;
        } else if (error) {
            console.error('Error fetching employee records:', error);
        }
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    handleEmployeeSelect(event) {
        this.selectedEmployeeId = event.detail.row.Id;
        this.loadEmployeeCharts();
    }


    loadEmployeeCharts() {
        this.isLoading = true;

        // Load Chart.js library
        if (this.chartJsJs) {
            this.initializeCharts();
            return;
        }

        loadScript(this, CHARTJS)
            .then(() => {
                this.chartJsJs = window.Chart;
                this.initializeCharts();
            })
            .catch(error => {
                console.error('Error loading Chart.js library', error);
            });
    }

    initializeCharts() {
        // Fetch Data for Charts
        Promise.all([
            getEmployeeGoals({ employeeId: this.selectedEmployeeId }),
           getEmployeeSkills({ employeeId: this.selectedEmployeeId }),
           getEmployeeAverageRating({ employeeId: this.selectedEmployeeId })
        ])
        .then(([goalData]) => {
            this.renderCharts(goalData);
            this.isLoading = false;
        })
        .catch(error => {
            console.error('Error fetching chart data', error);
            this.isLoading = false;
        });
    }
   

    
    

    renderCharts(goals) {
        const ctxGoals = this.template.querySelectorAll('.chart')[0].getContext('2d');
      //  const ctxRating = this.template.querySelectorAll('.chart')[1].getContext('2d');
     //   const ctxSkills = this.template.querySelectorAll('.chart')[2].getContext('2d');

        // Bar Chart for Goals
        new this.chartJsJs.Bar(ctxGoals, {
            data: {
                labels: ['Not Started', 'In Progress', 'Completed', 'Missed'],
                datasets: [{
                    label: 'Goals',
                    data: 'Not Started',
                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#E8C3C1'],
                }]
            },
            options: {
                responsive: true,
                scales: {
                    x: { beginAtZero: true },
                    y: { beginAtZero: true }
                }
            }
        });
    }
    calculateGoalStatusCounts(goals) {
        const counts = { 'Not Started': 0, 'In Progress': 0, 'Completed': 0, 'Missed': 0 };
        goals.forEach(goal => counts[goal.Status__c]++);
        return [counts['Not Started'], counts['In Progress'], counts['Completed'], counts['Missed']];
    }
}