document.addEventListener('DOMContentLoaded', function() {
    var slider = document.getElementById('slider');
    var painIntensity = document.getElementById('pain_intensity');
    var sliderValue = document.getElementById('slider-value');
    var sliderComments = document.getElementById('slider-comments');

    noUiSlider.create(slider, {
      start: 0,
      step: 1,
      range: {
        'min': 0,
        'max': 10
      },
      pips: {
        mode: 'positions',
        values: [0, 20, 40, 60, 80, 100],
        density: 10,
        format: {
          to: function(value) {
            if (value === '0') {
              return '痛くない';
            } else if (value === '10') {
              return '耐えがたい痛み';
            } else {
              return Math.floor(value);
            }
          }
        }
      }
    });

    slider.noUiSlider.on('update', function(values, handle) {
      painIntensity.value = values[handle];
      sliderValue.textContent = Math.floor(values[handle]);
    });
});