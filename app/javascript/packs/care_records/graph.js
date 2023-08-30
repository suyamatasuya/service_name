import Chart from 'chart.js/auto';

function calculateAverage(data, symptom, date) {
    let recordsForDate = data.filter(record => record.symptom === symptom && record.date === date);
    let sum = recordsForDate.reduce((acc, record) => acc + (record.face_scale || 0), 0);
    return recordsForDate.length ? sum / recordsForDate.length : null;
}

function createChartConfig(dates, data, label, color) {
    return {
        type: 'line',
        data: {
            labels: dates,
            datasets: [{
                label: label,
                data: data,
                borderColor: color,
                backgroundColor: `${color}0.5`
            }]
        },
        options: {
            scales: {
                x: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(128, 128, 128, 0.1)'  // グリッドラインの色
                    }
                },
                y: {
                    beginAtZero: true,
                    suggestedMax: 5,
                    grid: {
                        color: 'rgba(128, 128, 128, 0.1)'  // グリッドラインの色
                    },
                    ticks: {
                        callback: function(value, index, values) {
                            return faceScaleToEmoji(value);
                        }
                    }
                }
            }
        }
    };
}

function faceScaleToEmoji(face_scale) { 
  var faceScaleMap = {
    1: "😀",
    2: "🙂",
    3: "😐",
    4: "🙁",
    5: "😭"
  };
  return faceScaleMap[face_scale] || "";
}

$(document).ready(function() {
    $.get("/api/care_records", function(data) {
        let neckDates = [...new Set(data.filter(record => record.symptom === 'neck').map(record => record.date))].sort();
        let backDates = [...new Set(data.filter(record => record.symptom === 'back').map(record => record.date))].sort();

        let neckAverages = neckDates.map(date => calculateAverage(data, 'neck', date));
        let backAverages = backDates.map(date => calculateAverage(data, 'back', date));

        var neckCtx = document.getElementById('neckCareRecordsChart').getContext('2d');
        var backCtx = document.getElementById('backCareRecordsChart').getContext('2d');

        new Chart(neckCtx, createChartConfig(neckDates, neckAverages, '首のケア記録', 'rgb(255, 99, 132)'));
        new Chart(backCtx, createChartConfig(backDates, backAverages, '腰のケア記録', 'rgb(54, 162, 235)'));

        $('#neck-tab').on('click', function() {
            $('.tab-pane, .chart').removeClass('active');
            $('#neck, #neckCareRecordsChart').addClass('active');
        });

        $('#back-tab').on('click', function() {
            $('.tab-pane, .chart').removeClass('active');
            $('#back, #backCareRecordsChart').addClass('active');
        });
    });
});
