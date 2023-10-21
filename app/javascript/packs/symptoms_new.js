document.addEventListener('DOMContentLoaded', () => {
    Array.from(document.getElementsByClassName('custom-label')).forEach(label => {
        label.onclick = () => {
            Array.from(document.getElementsByClassName('custom-label')).forEach(otherLabel => {
                otherLabel.classList.remove('active');
            });
            label.classList.add('active');
        }
    });

    const form = document.querySelector('#symptom-form');

    const radioButtons = form.querySelectorAll('.form-check-input');
    radioButtons.forEach((radioButton) => {
        radioButton.addEventListener('change', function() {
            form.submit();
        });
    });
});
