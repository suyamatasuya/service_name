import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

function careTypeToJapanese(care_type) {
  var careTypeTranslations = {
    "strength_training": "筋トレ",
    "stretch": "ストレッチ",
    "other": "その他",
    "exercises": "エクササイズ",
  };

  return careTypeTranslations[care_type] || care_type;
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

          $('#modal-footer-submit-button').click(function() {
            var faceScale = $('#face-scale').val();

            if (faceScale < 1 || faceScale > 10) {
              alert("フェイススケールは1から10の間で入力してください。");
              return;
            }

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
          title += " - " + care_record.face_scale;
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
    $('#face-scale').val("");
  });
});
