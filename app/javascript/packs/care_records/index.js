import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

$(document).ready(function() {
  // Initialize the calendar first outside of the fetchCareRecords function
  var calendarEl = document.getElementById('calendar');
  var calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin ],
    initialView: 'dayGridMonth'
  });

  // Define a function to fetch care records and update the list
  var fetchCareRecords = function() {
    // First, clear the existing list and the calendar events
    $("#care-records-list").empty();
    calendar.removeAllEvents();

    // Then, fetch care records from the API
    $.get("/api/care_records", function(data) {
      // Loop over each care record and append it to the list
      data.forEach(function(care_record) {
        var item = $("<li></li>");
        var link = $("<a></a>").attr("href", "/care_records/" + care_record.id);
        var date = $("<span></span>").addClass("date").text(care_record.date);
        var careType = $("<span></span>").addClass("care-type").text(care_record.care_type);
        
        var editButton = $("<button></button>").text("Edit").click(function() {
          // The path should be '/care_records/:id/edit' for Rails resources
          window.location.href = '/care_records/' + care_record.id + '/edit';
        });
        
        var deleteButton = $("<button></button>").text("Delete").click(function() {
          $.ajax({
            url: '/api/care_records/' + care_record.id,
            type: 'DELETE',
            success: function(result) {
              // Remove the care record from the list
              item.remove();

              // Fetch the care records again to update the calendar
              fetchCareRecords();
            }
          });
        });

        // Add a completion button
        var completeButton = $("<button></button>").text(care_record.completed ? "Completed" : "Complete").click(function() {
          // The path should be '/api/care_records/:id/complete' for Rails resources
          $.ajax({
            url: '/api/care_records/' + care_record.id + '/complete',
            type: 'POST',
            success: function(result) {
              // Mark the care record as complete in the list
              item.addClass("completed");
              // Fetch the care records again to update the calendar
              fetchCareRecords();
            }
          });
        });

        // Mark the list item as completed if the care record is completed
        if (care_record.completed) {
          item.addClass("completed");
        }

        link.append(date, careType);
        item.append(link, editButton, deleteButton, completeButton);
        $("#care-records-list").append(item);
      });

      // Add the fetched care records to the calendar
      calendar.addEventSource(data.map(function(care_record) { // Convert care records into events
        return {
          title: care_record.care_type,
          start: care_record.date,
          // Set the event color based on the completed status
          color: care_record.completed ? 'green' : 'lightblue'
        };
      }));

      calendar.render();
    });
  };

  // Fetch care records when the page is loaded
  fetchCareRecords();
});
