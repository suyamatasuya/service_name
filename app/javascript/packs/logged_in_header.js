
    document.addEventListener("turbolinks:load", (event) => {
      const hamburger = document.querySelector(".hamburger");
      const sideBar = document.querySelector(".side-bar");

      // Apply the event listener to the hamburger menu
      hamburger.addEventListener("click", () => {
        sideBar.classList.toggle("open");
      });
    });