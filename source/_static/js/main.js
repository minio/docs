window.addEventListener("DOMContentLoaded", (event) => {
  const tocMenuEl = document.querySelector("#table-of-contents > ul.simple");
  var readModeLs = localStorage.getItem("read-mode");
  
  // --------------------------------------------------
  // Detect macOS
  // --------------------------------------------------
  function isMac() {
    return navigator.platform.toUpperCase().indexOf('MAC') >= 0;
  }


  // --------------------------------------------------
  // Detect parent iframe.
  // This is required to hide the navigation links when viewed via PathFactory for analytics purposes
  // --------------------------------------------------
  (function () {
    if (window.location !== window.parent.location) {
      document.body.classList.add("inside-iframe");
    }
  })();


  // --------------------------------------------------
  // Read mode
  // --------------------------------------------------
  (function () {
    const readModeEl = document.getElementById("read-mode-toggle");
    const headerEl = document.querySelector(".header");
    
    // Check if the read mode in enabled in user's local storage
    if (readModeLs === "true") {
      document.documentElement.classList.add("read-mode");
      readModeEl.classList.add("active");
    }

    // Make header visible after the page is loaded and read-mode is decided.
    // This is to prevent the flickering of the header on page load.
    headerEl.classList.remove("inactive");
    
    // Toggle read mode on icon click
    readModeEl.addEventListener("click", (event) => {
      document.documentElement.classList.toggle("read-mode");

      if (document.documentElement.classList.contains("read-mode")) {
        localStorage.setItem("read-mode", "true");
      } else {
        localStorage.setItem("read-mode", "false");
      }
    });

    // Turn on read mode on smaller screen size.
    // Kinda like the responsive design.
    function resize() {
      readModeLs = localStorage.getItem("read-mode");

      if (window.innerWidth < 1280) {
        if (readModeLs == null || readModeLs == "false") {
          document.documentElement.classList.add("read-mode");
        }
      } else {
        if (readModeLs == "false") {
          document.documentElement.classList.remove("read-mode");
        }
      }
    }

    var resizeTimer;
    window.addEventListener("resize", function () {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function () {
        resize();
      }, 50);
    });

    resize();
  })();


  // --------------------------------------------------
  // Dark mode
  // --------------------------------------------------
  (function () {
    const darkModeEl = document.getElementById("dark-mode-toggle");
    var darkModeLs = localStorage.getItem("dark-mode");

    // Check if the dark mode in enabled in user's local storage
    if (darkModeLs === "true") {
      document.documentElement.classList.add("dark-mode");
      darkModeEl.classList.add("active");
    }

    darkModeEl.addEventListener("click", (event) => {
      document.documentElement.classList.toggle("dark-mode");

      if (document.documentElement.classList.contains("dark-mode")) {
        localStorage.setItem("dark-mode", "true");
      } else {
        localStorage.setItem("dark-mode", "false");
      }
    });
  })();


  // --------------------------------------------------
  // Get meta key based on the OS
  // --------------------------------------------------
  (function () {
    const metaKeyEl = document.getElementById("search-meta-key");
    
    if(metaKeyEl) {
      if(isMac()) {
        metaKeyEl.innerHTML = "⌘";
      }
      else {
        metaKeyEl.classList.add("ctrl");
        metaKeyEl.innerHTML = "Ctrl";
      }
    }
  })();


  // --------------------------------------------------
  // TOC
  // --------------------------------------------------
  (function () {
    // Move the TOC to the right side of the page
    const tocOriginalEl = document.getElementById("table-of-contents");
    const tocTargetEl = document.getElementById("content-toc");
    const tocAsideEL = document.querySelector(".content__toc");

    if (tocOriginalEl) {
      tocTargetEl.parentNode.replaceChild(tocOriginalEl, tocTargetEl);
    }
    else {
      tocAsideEL.style.display = "none";
    }

    
    // Treat the TOC as a dropdown in mobile
    const tocToggleEl = document.querySelector(".topic-title");
    if(tocToggleEl) {
      tocToggleEl.addEventListener("click", (event) => {
        event.preventDefault();
        tocMenuEl.closest(".content__toc").classList.toggle("active");
      });
    }
  })();


  // --------------------------------------------------
  // Cookie banner
  // --------------------------------------------------
  (function () {
    var cookieLs = localStorage.getItem("set-cookie");
    const cookieBanner = document.getElementById("cookie");
    if (cookieLs == null) {
      cookieBanner.classList.add("show");
    }

    cookieBanner.addEventListener("click", (event) => {
      localStorage.setItem("set-cookie", "true");
      cookieBanner.classList.remove("show");
    });
  })();


  // --------------------------------------------------
  // Content Nav
  // --------------------------------------------------
  (function () {
    const contentNav = document.querySelectorAll("[data-content-nav]");
    contentNav.forEach((nav) => {
      nav.addEventListener("click", (event) => {
        event.preventDefault();
        var target = nav.getAttribute("data-content-nav");

        document
          .querySelector(".content__nav__inner a.active")
          .classList.remove("active");
        document
          .querySelector(".content__nav__dropdown nav.active")
          .classList.remove("active");
        document.getElementById(target).classList.add("active");
        nav.classList.add("active");
      });
    });
  })();


  // --------------------------------------------------
  // Search
  // --------------------------------------------------
  (function () {
    const searchToggleEl = document.querySelectorAll(".search-toggle");
    const searchParentEl = document.querySelector(".header__hero");
    const searchInputEl = document.querySelector(".search__text");
    const searchCloseEl = document.getElementById("search-close");
    const searchDocEL = document.getElementById("search-documentation")

    if(searchInputEl) {
      // Open
      searchToggleEl.forEach((item) => {
        item.addEventListener("click", (event) => {
          // Hide opened toc menu on mobile
          if(tocMenuEl) {
            tocMenuEl.closest(".content__toc").classList.remove("active");
          }

          // Toggle search
          searchParentEl.classList.add("active");
          searchInputEl.focus();
        });
      });

      // Close
      searchCloseEl.addEventListener("click", (event) => {
        searchParentEl.classList.remove("active");
        searchInputEl.value = "";
      });
    }

    // Add ID to search result page
    if(searchDocEL) {
      document.documentElement.classList.add("search-doc");
    }
  })();

  
  // --------------------------------------------------
  // Asides: Sidebar and Nav
  // --------------------------------------------------
  (function () {
    const asideToggleEls = document.querySelectorAll("[data-aside-toggle]");
    const sidebarEl = document.querySelector(".sidebar");
    const navEl = document.querySelector(".nav");
    const asideHideEls = document.querySelectorAll(".hide-aside");

    function hideAside() {
      document.querySelector(".aside-backdrop").remove();
      document.documentElement.classList.remove("doc-active", "nav-active");

      // Hide opened toc menu on mobile
      if(tocMenuEl) {
        tocMenuEl.closest(".content__toc").classList.remove("active");
      }
    }

    asideToggleEls.forEach((item) => {
      item.addEventListener("click", (event) => {
        event.preventDefault();
        var target = item.getAttribute("data-aside-toggle");

        document.documentElement.classList.add(target + "-active");

        var backdrop = document.createElement("div");
        backdrop.classList.add("aside-backdrop");
        backdrop.onclick = function () {
          document.documentElement.classList.remove(target + "-active");
          backdrop.remove();
        }

        if(target == "doc") {
          sidebarEl.insertAdjacentElement("afterend", backdrop);
        }
        else {
          navEl.insertAdjacentElement("afterend", backdrop);
        }
      });
    });

    asideHideEls.forEach(item => {
      item.addEventListener("click", (event) => {
        event.preventDefault();
        hideAside();
      });
    });
  })();


  // --------------------------------------------------
  // Icon switches
  // e.g Read mode and Dark mode buttons
  // --------------------------------------------------
  (function () {
    const iconSwitchesEls = document.querySelectorAll(".icon--switch");
    iconSwitchesEls.forEach((item) => {
      item.addEventListener("click", (event) => {
        event.preventDefault();
        item.classList.toggle("active");
      });
    });
  })();


  // --------------------------------------------------
  // Focus search input on key combination
  // --------------------------------------------------
  (function () {
    const root = document.documentElement;

    document.addEventListener("keydown", (event) => {
      if(!root.classList.contains("read-mode")) {
        const searchInputEl = document.querySelector(".search__text");
        var metaKey = isMac() ? event.metaKey : event.ctrlKey

        if (metaKey && event.key === "/") {
          searchInputEl.focus();
          window.scrollTo(0, 0);
        }
      }
    });
  })();
  

  // --------------------------------------------------
  // Inserts the personas into the left-hand nav
  // --------------------------------------------------
  (function() {
    const operationPersona = document.createElement("li");
    operationPersona.innerHTML = "Operations";
    operationPersona.className = "docs__title";
 
    const administrationPersona = document.createElement("li");
    administrationPersona.innerHTML = "Administration";
    administrationPersona.className = "docs__title";
 
    const developerPersona = document.createElement("li");
    developerPersona.innerHTML = "Developers";
    developerPersona.className = "docs__title";
 
    const referencePersona = document.createElement("li");
    referencePersona.innerHTML = "Reference";
    referencePersona.className = "docs__title";
 
    const list = document.getElementsByClassName("toctree-l1");
 
    for ( i = 0; i < list.length; i++) {
      const page_title = list[i].childNodes[0].innerHTML;
      if (page_title === "Install and Deploy MinIO" || page_title === "Deploy the MinIO Operator") {
        // First persona is not listed in the design, so commenting it for now. 
        //list[i].insertAdjacentElement('beforebegin',operationPersona);
      }
      else if (page_title === "MinIO Console") {
        list[i].insertAdjacentElement('beforebegin',administrationPersona);
      }
      else if (page_title === "Software Development Kits (SDK)") {
        list[i].insertAdjacentElement('beforebegin',developerPersona);
      }
      else if (page_title === "MinIO Client") {
        list[i].insertAdjacentElement('beforebegin',referencePersona);
      }
    }
  })();


  // --------------------------------------------------
  // Responsive tables
  // --------------------------------------------------
  (function () {
    const tableEls = document.querySelectorAll("table");
    if(tableEls.length > 0) {
      tableEls.forEach((item) => {
        var tableWrapper = document.createElement("div");
        tableWrapper.classList.add("table-responsive", "scrollbar");
        item.insertAdjacentElement("beforebegin", tableWrapper);
        tableWrapper.appendChild(item);
      });
    }
  })();
});