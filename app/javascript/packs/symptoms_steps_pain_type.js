document.addEventListener('DOMContentLoaded', function(){
  const form = document.querySelector('#symptom-pain-type-form');

  document.querySelectorAll('.custom-label').forEach(function(label){
      label.addEventListener('click', function(e){
          // Clear previous selection
          document.querySelectorAll('.custom-label').forEach(function(otherLabel){
              otherLabel.classList.remove('active');
          })
          // Set the clicked label as active
          e.currentTarget.classList.add('active');

          // Submit the form when a radio button is selected
          form.submit();
      })
  })
});
