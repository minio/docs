window.addEventListener("DOMContentLoaded", (event) => {
  const tocMenuEl = document.querySelector("#table-of-contents > ul.simple");
  const root = document.documentElement;
  var readModeLs = localStorage.getItem("read-mode");

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
  // Dynamic sidebar scroll on non read-mode.
	// This'll allow the sidebar to display all content,
	// without scrolling the body. 
  // --------------------------------------------------
  const sidebarEl = document.querySelector(".sidebar");
  const headerEl = document.querySelector(".header");
  const activeDocEl = document.querySelector(".docs a.current");
  const tocEl = document.querySelector(".content__toc");

  function setSidebarHeight() { //TODO: Clean this up
    var headerViewHeight = headerEl.clientHeight - root.scrollTop;
    var sidebarHeight = headerViewHeight > 0 ? `calc(100vh - ${headerViewHeight}px)` : "100vh";
    var sidebarReadModeHeight = window.innerWidth > 991 ? sidebarHeight : "100vh";
      
    if(!root.classList.contains("read-mode")) {
      sidebarEl.style.setProperty("height", sidebarHeight);
      tocEl.style.setProperty("height", sidebarHeight);
    }
    else {
      sidebarEl.style.setProperty("height", sidebarReadModeHeight);
      
      if(window.innerWidth > 991) {
        tocEl.style.setProperty("height", sidebarReadModeHeight);
      }
      else {
        tocEl.style.removeProperty("height");
      }
    }
  }
  
  setTimeout(() => {
    setSidebarHeight();
    
    // Scroll sidebar to active doc items
    if(activeDocEl && activeDocEl.offsetTop > 400) {
      sidebarEl.scrollTop = activeDocEl.offsetTop - 40;
    }
    
    // Make the sidebar is scrollable.
    sidebarEl.classList.remove("inactive");

    // Scroll to hash
    var hash = window.location.hash;
    if (hash) {
      var el = document.querySelector(hash);
      if (el) {
        el.scrollIntoView();
      }
    }
  }, 100);

  document.addEventListener("scroll", (e) => {
    setSidebarHeight();
  });
 
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

			// Re-calculate sidebar height
      setSidebarHeight();

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

			// Re-calculate sidebar height
			setSidebarHeight();
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
  // TOC, External Links
  // --------------------------------------------------
  (function () {
    // Move the TOC, External Links, etc. to the right side of the page
    const extVideoLinks = document.querySelector(".extlinks-video")

    const tocPreferredEl = document.getElementById("table-of-contents");
    const tocLegacyEl = document.getElementById("content-toc");

    // This is the target element for the "aside" or right nav bar
    const tocAsideEl = document.querySelector(".content__toc");

    // Don't need this element so remove it
    tocLegacyEl.remove();

    // Build an array of elements to add, in order
    // Then iterate the array and append it, one by one, to the aside
    const asideElements = new Array();

    if (tocPreferredEl) {
      asideElements.push(tocPreferredEl);
    }
    if (extVideoLinks) {
      // Minor cleanups to the CSS classes
      extVideoLinks.classList.remove("docutils", "container")
      extVideoLinks.classList.add("topic")

      // Inject the header text

      const extVideoLinkHeader = document.createElement("div");
      extVideoLinkHeader.classList.add("extVideoLink-header");
      extVideoLinkHeader.innerHTML += "<p>Recommended Videos</p>";
      extVideoLinks.prepend(extVideoLinkHeader);


      asideElements.push(extVideoLinks)

      // Need to force-add extlinks, they don't seem to get added as-is for some reason

      const extVideoItems = document.querySelectorAll(".extlinks-video a");
      extVideoItems.forEach(item => {
         item.setAttribute("target","_blank");
         item.setAttribute("rel", "noopener");
         item.setAttribute("rel", "noreferrer");
      });
    }

    // Sets the empty CSS class if nothing on the page goes in the sidebar
    if (asideElements.length == 0) {
      tocAsideEl.classList.add("content__toc--empty");
    }
    else {
      for (i = 0; i < asideElements.length; i++) {
         tocAsideEl.appendChild(asideElements[i]);
       }
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
          .querySelector(".platform-nav__inner a.active")
          .classList.remove("active");
        document
          .querySelector(".platform-nav__dropdown nav.active")
          .classList.remove("active");
        document.getElementById(target).classList.add("active");
        nav.classList.add("active");
      });
    });
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


  // --------------------------------------------------
  // Headerlink wrappers
  // --------------------------------------------------
  (function () {
    const headerlinkEls = document.querySelectorAll(".headerlink");
    if(headerlinkEls.length > 0) {
      headerlinkEls.forEach((item) => {
        var parent = item.parentNode;
        parent.classList.add("headerlink-wrapper");
      });
    }
  })();

  // --------------------------------------------------
  // Custom scrollbars for `pre` code blocks
  // --------------------------------------------------
  (function () {
    const preEls = document.querySelectorAll(".highlight pre");
    if(preEls.length > 0) {
      preEls.forEach((item) => {
        item.classList.add("scrollbar");
      });
    }
  })();

  // --------------------------------------------------
  // Handle internal and external links
  // --------------------------------------------------
  (function () {
    const links = document.querySelectorAll(".content__main a.external");
    if(links.length > 0) {
      links.forEach((item) => {
        item.setAttribute("target", "_blank");
        item.setAttribute("rel", "noopener");
        item.setAttribute("rel", "noreferrer");
      });
    }
  })();

  // --------------------------------------------------
  // Carousel
  // --------------------------------------------------
  (function () {
    const carousels = document.querySelectorAll(".sd-cards-carousel");
    var scrollLength = 1000;

    const arrowIcon = `<svg width="13" height="10" viewBox="0 0 12 10">
                    <path d="M1.707 4.137H11.5c.277 0 .5.23.5.516 0 .137-.051.27-.145.363s-.223.152-.355.152H1.707l3.148 3.254a.53.53 0 0 1 0 .73c-.098.102-.223.152-.355.152s-.258-.051-.355-.152l-4-4.133c-.195-.203-.195-.531 0-.734l4-4.133A.5.5 0 0 1 4.5 0a.5.5 0 0 1 .355.152.53.53 0 0 1 0 .73zm0 0" fill-rule="evenodd" fill="currentColor" />
                  </svg>`;

    function toggleArrows(elem, arrowLeft, arrowRight) {
      var scrollWidth = elem.scrollWidth;
      var scrollLeft = elem.scrollLeft + elem.clientWidth;

      // Set the scroll length based on the window width
      window.innerWidth < 1400 ? scrollLength = 500 : scrollLength = 1000;

      scrollWidth - scrollLeft <= 1
        ? arrowRight.classList.add("inactive")
        : arrowRight.classList.remove("inactive");
      scrollLeft === elem.clientWidth
        ? arrowLeft.classList.add("inactive")
        : arrowLeft.classList.remove("inactive");
    }

    if(carousels.length > 0) {
      carousels.forEach((item) => {
        // Get the amount of columns
        const colsAmount = item.className.match(/(^|\s)sd-card-cols-(\w+)/g).pop().split('-').pop();

        // Wrap the carousel in a div
        const wrapper = document.createElement("div");
        wrapper.classList.add("carousel-wrapper");
        item.insertAdjacentElement("beforebegin", wrapper);

        // Create the arrows
        const arrowLeft = document.createElement("button");
        arrowLeft.classList.add("carousel-arrow", "carousel-arrow--left");
        arrowLeft.innerHTML = arrowIcon;
        arrowLeft.onclick = function() {
          item.scrollLeft -= scrollLength/colsAmount;
        }

        const arrowRight = document.createElement("button");
        arrowRight.classList.add("carousel-arrow", "carousel-arrow--right");
        arrowRight.innerHTML = arrowIcon;
        arrowRight.onclick = function() {
          item.scrollLeft += scrollLength/colsAmount;
        }
        
        wrapper.insertAdjacentElement("afterbegin", arrowLeft);
        wrapper.insertAdjacentElement("beforeend", arrowRight);

        // Move the carousel into the wrapper
        wrapper.appendChild(item);

        // Toggle arrows on manual scroll
        item.addEventListener("scroll", () => {
          toggleArrows(item, arrowLeft, arrowRight);
        });
        toggleArrows(item, arrowLeft, arrowRight);
      });
    }
  })();
});