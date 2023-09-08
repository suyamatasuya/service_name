document.addEventListener("turbolinks:load", (event) => {
  const hamburger = document.querySelector(".hamburger");
  const sideBar = document.querySelector(".side-bar");
  const navbarLinks = document.querySelectorAll(".navbar-links");

  hamburger.addEventListener("click", () => {
    hamburger.classList.toggle("open");
    sideBar.classList.toggle("open");
    for (let link of navbarLinks) {
      link.style.display = 'none';
    }
  });

  window.addEventListener('resize', () => {
    if (window.innerWidth > 768) {
      for (let link of navbarLinks) {
        link.style.display = 'block';
        link.classList.remove("nav-link");
      }
      sideBar.classList.remove("open");
      hamburger.classList.remove("open");
    } else {
      if (!sideBar.classList.contains("open")) {
        for (let link of navbarLinks) {
          link.style.display = 'none';
          link.classList.add("nav-link");
        }
      }
    }
  });
});
