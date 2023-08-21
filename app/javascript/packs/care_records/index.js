import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

window.Calendar = Calendar;
window.dayGridPlugin = dayGridPlugin;


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

$(document).ready(function() {
  var calendarEl = document.getElementById('calendar');

  var myModal = new bootstrap.Modal(document.getElementById('careRecordModal'));
  var completionModal = new bootstrap.Modal(document.getElementById('completionModal'));

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
          "symptom": "部位",
          "description": "説明",
        };
        var details = "";
        for (var field in data) {
          var value = data[field];
          if (field === 'care_type') {
            value = careTypeToJapanese(value);
          }
          if (field === 'symptom') {
            value = value === 'neck' ? '首' : value === 'back' ? '腰' : value;
          }
          if (fieldTranslations[field]) {
            details += fieldTranslations[field] + ": " + value + "\n";
          }
        }
        $("#careRecordModal .modal-body").text(details);
        $("#careRecordModal").data('record-id', info.event.id);
        var myModal = new bootstrap.Modal(document.getElementById('careRecordModal'));
        myModal.show();

      });
    }
  });

  calendar.render();

  // 以下のコードは変更なしで継続します

  $("#edit-button").click(function() {
    var recordId = $("#careRecordModal").data('record-id');
    window.location.href = '/care_records/' + recordId + '/edit';
  });

  $("#delete-button").click(function() {
    var recordId = $("#careRecordModal").data('record-id');
    $.ajax({
      url: '/api/care_records/' + recordId,
      type: 'DELETE',
      success: function(result) {
        myModal.hide();
        fetchCareRecords();
      }
    });
  });

  $("#complete-button").click(function() {
    var recordId = $("#careRecordModal").data('record-id');
    completionModal.show();
    $(".face-scale-option").off().click(function() {
      var faceScale = $(this).data('face-scale');
      completionModal.hide();
      $.ajax({
        url: '/api/care_records/' + recordId + '/complete',
        type: 'POST',
        data: { face_scale: faceScale },
        success: function(result) {
          fetchCareRecords();
        }
      });
    });
  });

  var fetchCareRecords = function() {
    calendar.removeAllEvents();
    $.get("/api/care_records", function(data) {
      data.forEach(function(care_record) {
        var title = careTypeToJapanese(care_record.care_type);
        if (care_record.symptom) {
            title = care_record.symptom === 'neck' ? '首: ' + title : '腰: ' + title;
        }
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
    });
  };

  fetchCareRecords();
});
