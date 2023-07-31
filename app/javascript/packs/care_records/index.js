import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import Highcharts from 'highcharts';

function careTypeToJapanese(care_type) {
  var careTypeTranslations = {
    "strength_training": "筋トレ",
    "stretch": "ストレッチ",
    "other": "その他",
    "exercise": "エクササイズ",
  };

  return careTypeTranslations[care_type] || care_type;
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

function drawGraph() {
  $.get("/api/care_records", function(data) {
    var categories = ["筋トレ", "ストレッチ", "その他", "エクササイズ"];
    var seriesData = [0, 0, 0, 0];

    data.forEach(function(care_record) {
      var careTypeIndex = categories.indexOf(careTypeToJapanese(care_record.care_type));
      if (careTypeIndex !== -1) {
        seriesData[careTypeIndex] += care_record.face_scale || 0;
      }
    });

    var chart = Highcharts.chart('graph-container', {
      chart: {
        type: 'column'
      },
      title: {
        text: 'ケアの種類別の平均痛みの強さ'
      },
      xAxis: {
        categories: categories
      },
      yAxis: {
        min: 0,
        title: {
          text: '平均痛みの強さ'
        }
      },
      series: [{
        name: 'ケアの種類',
        data: seriesData
      }]
    });
  });
}

$(document).ready(function() {
  var calendarEl = document.getElementById('calendar');
  var calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin ],
    initialView: 'dayGridMonth',
    locale: 'ja',
    buttonText: {
      today: '今日'
    },
    eventClick: function(info) {
      info.jsEvent.preventDefault();
      $.get("/api/care_records/" + info.event.id, function(data) {
        var fieldTranslations = {
          "date": "日付",
          "care_type": "ケアタイプ",
          "duration": "時間",
          "description": "説明",
        };

        var details = "";
        for (var field in data) {
          var value = data[field];
          if (field === 'care_type') {
            value = careTypeToJapanese(value);
          }
          if (field === 'duration' && value === null) {
            continue;
          }
          if (field === 'description' && value === "") {
            continue;
          }
          if (fieldTranslations[field]) {
            details += fieldTranslations[field] + ": " + value + "\n";
          }
        }

        $("#careRecordModal .modal-body").text(details);
        $("#careRecordModal").modal('show');
      });
    }
  });

  var fetchCareRecords = function() {
    $("#care-records-list").empty();
    calendar.removeAllEvents();

    $.get("/api/care_records", function(data) {
      data.forEach(function(care_record) {
        var item = $("<li></li>");
        var link = $("<a></a>").attr("href", "/care_records/" + care_record.id);
        var date = $("<span></span>").addClass("date").text(care_record.date);
        var careType = $("<span></span>").addClass("care-type").text(careTypeToJapanese(care_record.care_type));
        var duration = $("<span></span>").addClass("duration").text(care_record.duration);

        var editButton = $("<button></button>").text(window.translations.edit_button).click(function() {
          window.location.href = '/care_records/' + care_record.id + '/edit';
        });

        var deleteButton = $("<button></button>").text(window.translations.delete_button).click(function() {
          $.ajax({
            url: '/api/care_records/' + care_record.id,
            type: 'DELETE',
            success: function(result) {
              item.remove();
              fetchCareRecords();
            }
          });
        });

        var completeButton = $("<button></button>").text(care_record.completed ? window.translations.complete_button.completed : window.translations.complete_button.complete).click(function() {
          if (care_record.completed) {
            return;
          }

          $("#completionModal").modal('show');

          $(".face-scale-option").off().click(function() {
            var faceScale = $(this).data('face-scale');

            $("#completionModal").modal('hide');

            $.ajax({
              url: '/api/care_records/' + care_record.id + '/complete',
              type: 'POST',
              data: { face_scale: faceScale },
              success: function(result) {
                item.addClass("completed");
                fetchCareRecords();
              }
            });
          });
        });

        if (care_record.completed) {
          item.addClass("completed");
        }

        link.append(date, careType, duration);
        item.append(link, editButton, deleteButton, completeButton);
        $("#care-records-list").append(item);

        var title = careTypeToJapanese(care_record.care_type);
        if (care_record.completed && care_record.face_scale !== null) {
          title += " - " + faceScaleToEmoji(care_record.face_scale); 
        }

        calendar.addEvent({
          id: care_record.id,
          title: title,
          start: care_record.date,
          color: care_record.completed ? 'green' : 'lightblue'
        });
      });

      calendar.render();
    });
  };

  fetchCareRecords();

  $('#completionModal').on('hidden.bs.modal', function (e) {
    $(".face-scale-option").removeClass("selected"); 
  });

  $('#completionModal').on('click', '.close, .btn-close', function () {
    $('#completionModal').modal('hide');
  });

  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    if (e.target.id === 'graph-tab') {
      drawGraph();
    }
  });
});
