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
                    beginAtZero: true
                },
                y: {
                    beginAtZero: true,
                    suggestedMax: 5,
                    ticks: {
                        callback: function(value, index, values) {
                            return faceScaleToEmoji(value); // この部分で縦軸のラベルを顔文字に変更
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

        // タブの切り替え処理
        $('#neckTab').on('click', function() {
            $('.tab, .chart').removeClass('active');
            $('#neckTab, #neckCareRecordsChart').addClass('active');
        });

        $('#backTab').on('click', function() {
            $('.tab, .chart').removeClass('active');
            $('#backTab, #backCareRecordsChart').addClass('active');
        });
    });
});
