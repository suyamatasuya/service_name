
  document.addEventListener('DOMContentLoaded', function(){
    document.querySelectorAll('.custom-label').forEach(function(label){
      label.addEventListener('click', function(e){
        // Clear previous selection
        document.querySelectorAll('.custom-label').forEach(function(otherLabel){
          otherLabel.classList.remove('active');
        })
        // Set the clicked label as active
        e.currentTarget.classList.add('active');
      })
    })
})