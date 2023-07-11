document.addEventListener('DOMContentLoaded', (event) => {
    const startButton = document.querySelector('.start-button');

    startButton.addEventListener('mousedown', () => {
      startButton.classList.add('clicked');
    });

    startButton.addEventListener('mouseup', () => {
      startButton.classList.remove('clicked');
    });
});