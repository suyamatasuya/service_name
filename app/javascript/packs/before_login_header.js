document.addEventListener("turbolinks:load", (event) => {
  const hamburger = document.querySelector(".hamburger");
  const sideBar = document.querySelector("#mySidebar");
  const navbarLinks = document.querySelectorAll(".nav-link");

  if (hamburger && sideBar && navbarLinks.length > 0) {
    hamburger.addEventListener("click", () => {
      sideBar.style.width = sideBar.style.width === '250px' ? '0' : '250px';
      for (let link of navbarLinks) {
        link.style.display = sideBar.style.width === '250px' ? 'block' : 'none';
      }
    });

    window.addEventListener('resize', () => {
      if (window.innerWidth > 768) {
        sideBar.style.width = '0';
        for (let link of navbarLinks) {
          link.style.display = 'block';
          link.classList.remove("nav-link");
        }
      } else {
        if (sideBar.style.width === '250px') {
          for (let link of navbarLinks) {
            link.style.display = 'none';
            link.classList.add("nav-link");
          }
        }
      }
    });
  }
});
