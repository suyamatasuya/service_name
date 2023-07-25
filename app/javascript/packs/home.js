window.onload = function() {
  anime({
    targets: '.left-text p, .title-text, .cta-button, .board-link, .care-records-link',
    opacity: [0, 1],
    duration: 2000,
    delay: anime.stagger(500), // Each element will start animating 500ms after the previous one
    easing: 'easeInOutSine',
  });
};
