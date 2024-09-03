import { LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/ChartJS';

export default class MyChartComponent extends LightningElement {
    chart;

    renderedCallback() {
        if (this.chartInitialized) {
            return;
        }
        this.chartInitialized = true;

        // Load the Chart.js script
        loadScript(this, CHARTJS)
            .then(() => {
                this.initializeChart();
            })
            .catch(error => {
                console.error('Error loading Chart.js', error);
            });
    }

    initializeChart() {
        const ctx = this.template.querySelector('canvas').getContext('2d');
        this.chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
                datasets: [{
                    label: '# of Votes',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
}
