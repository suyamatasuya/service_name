document.addEventListener('DOMContentLoaded', () => {
    Array.from(document.getElementsByClassName('custom-label')).forEach(label => {
        label.onclick = () => {
            Array.from(document.getElementsByClassName('custom-label')).forEach(otherLabel => {
                otherLabel.classList.remove('active');
            })
            label.classList.add('active');
        }
    })
})