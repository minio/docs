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
  // Dynamic sidebar scroll on read-mode.
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
      tocAsideEL.classList.add("content__toc--empty");
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
  // Search
  // --------------------------------------------------
  (function () {
    const docSearchEl = document.getElementById("docsearch");
    const platform = document.head.querySelector('meta[name="docsearch:platform"]').content
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
  // Search
  // --------------------------------------------------
  const searchToggleEl = document.querySelectorAll(".search-toggle");
  const searchModalEl = document.getElementById("search-modal");
  const activePlatform = document.getElementsByTagName('meta')['docsearch:platform'].getAttribute('content');

  const icons = {
    h1: `<svg width="14" height="9">
          <path d="M1.259 9a.5.5 0 0 1-.5-.5V.773a.5.5 0 0 1 .5-.5h.845a.5.5 0 0 1 .5.5v3.001a.1.1 0 0 0 .1.1H6.25a.1.1 0 0 0 .1-.1V.773a.5.5 0 0 1 .5-.5h.841a.5.5 0 0 1 .5.5V8.5a.5.5 0 0 1-.5.5H6.85a.5.5 0 0 1-.5-.5V5.495a.1.1 0 0 0-.1-.1H2.704a.1.1 0 0 0-.1.1V8.5a.5.5 0 0 1-.5.5h-.845zM12.957.273a.5.5 0 0 1 .5.5V8.5a.5.5 0 0 1-.5.5h-.845a.5.5 0 0 1-.5-.5V2.064a.04.04 0 0 0-.04-.04h0a.04.04 0 0 0-.021.006l-1.223.767a.5.5 0 0 1-.766-.424v-.458a.5.5 0 0 1 .233-.422L11.601.35a.5.5 0 0 1 .268-.078h1.089z"/>
        </svg>`,
    h2: `<svg width="16" height="9">
          <path d="M1.259 9a.5.5 0 0 1-.5-.5V.773a.5.5 0 0 1 .5-.5h.845a.5.5 0 0 1 .5.5v3.001a.1.1 0 0 0 .1.1H6.25a.1.1 0 0 0 .1-.1V.773a.5.5 0 0 1 .5-.5h.841a.5.5 0 0 1 .5.5V8.5a.5.5 0 0 1-.5.5H6.85a.5.5 0 0 1-.5-.5V5.495a.1.1 0 0 0-.1-.1H2.704a.1.1 0 0 0-.1.1V8.5a.5.5 0 0 1-.5.5h-.845zm8.902 0a.5.5 0 0 1-.5-.5v-.611a.5.5 0 0 1 .16-.367l2.946-2.728.665-.69a2.62 2.62 0 0 0 .413-.601 1.49 1.49 0 0 0 .141-.643 1.21 1.21 0 0 0-.175-.661c-.117-.185-.276-.331-.477-.43s-.43-.153-.686-.153c-.267 0-.5.054-.699.162a1.12 1.12 0 0 0-.46.464c-.038.071-.069.146-.094.227-.081.264-.292.493-.568.493h-.751c-.276 0-.505-.225-.464-.498.055-.366.172-.696.352-.989A2.59 2.59 0 0 1 11.05.499c.466-.23 1.003-.345 1.611-.345.625 0 1.169.111 1.632.332a2.59 2.59 0 0 1 1.087.912c.258.389.388.835.388 1.338a2.56 2.56 0 0 1-.196.976c-.131.321-.357.678-.686 1.07s-.794.857-1.393 1.402l-1.274 1.249v.06h3.165a.5.5 0 0 1 .5.5V8.5a.5.5 0 0 1-.5.5h-5.222z"/>
        </svg>`,
    h3: `<svg width="17" height="10">
          <path d="M1.259 9a.5.5 0 0 1-.5-.5V.773a.5.5 0 0 1 .5-.5h.845a.5.5 0 0 1 .5.5v3.001a.1.1 0 0 0 .1.1H6.25a.1.1 0 0 0 .1-.1V.773a.5.5 0 0 1 .5-.5h.841a.5.5 0 0 1 .5.5V8.5a.5.5 0 0 1-.5.5H6.85a.5.5 0 0 1-.5-.5V5.495a.1.1 0 0 0-.1-.1H2.704a.1.1 0 0 0-.1.1V8.5a.5.5 0 0 1-.5.5h-.845zm11.627.119c-.636 0-1.203-.109-1.7-.328s-.885-.526-1.172-.912a2.24 2.24 0 0 1-.381-.842c-.06-.273.171-.504.451-.504h.875c.266 0 .471.221.606.45a.99.99 0 0 0 .077.112c.131.159.304.283.52.371s.459.132.729.132c.281 0 .53-.05.746-.149a1.22 1.22 0 0 0 .507-.413c.122-.176.183-.379.183-.609a1.02 1.02 0 0 0-.196-.618c-.128-.182-.312-.324-.554-.426s-.523-.153-.852-.153h-.314a.5.5 0 0 1-.5-.5v-.355a.5.5 0 0 1 .5-.5h.314a1.77 1.77 0 0 0 .737-.145c.216-.097.383-.23.503-.401a1.04 1.04 0 0 0 .179-.605c0-.219-.053-.411-.158-.575a1.04 1.04 0 0 0-.435-.392c-.185-.094-.401-.141-.648-.141a1.69 1.69 0 0 0-.686.136 1.2 1.2 0 0 0-.499.379.98.98 0 0 0-.077.119c-.13.235-.335.461-.604.461h-.779c-.279 0-.511-.232-.45-.504.067-.3.191-.575.372-.825.278-.384.653-.683 1.125-.899s1.01-.328 1.607-.328c.602 0 1.129.109 1.581.328s.803.514 1.053.886a2.15 2.15 0 0 1 .375 1.244c.003.489-.149.896-.456 1.223a2.08 2.08 0 0 1-1.189.622v.068c.642.082 1.131.305 1.466.669s.506.813.503 1.355a2.13 2.13 0 0 1-.43 1.325c-.287.386-.683.69-1.189.912s-1.085.332-1.739.332z"/>
        </svg>`,
    content: `<svg width="15" height="10">
                <path d="M0 .75A.75.75 0 0 1 .75 0h13.5a.75.75 0 1 1 0 1.5H.75A.75.75 0 0 1 0 .75zm0 4A.75.75 0 0 1 .75 4h13.5a.75.75 0 1 1 0 1.5H.75A.75.75 0 0 1 0 4.75zm0 4A.75.75 0 0 1 .75 8h13.5a.75.75 0 1 1 0 1.5H.75A.75.75 0 0 1 0 8.75z"/>
              </svg>`
  };

  function initInstaSearch() {
    const algoliaClient = algoliasearch(
      'E1CSOK3UC2',
      '6bc246d81fd3b79f51cf88f0b2481bac'
    );

    const searchClient = {
      ...algoliaClient,
      search(requests) {
        if (requests.every(({ params }) => !params.query)) {
          return Promise.resolve({
            results: requests.map(() => ({
              hits: [],
              nbHits: 0,
              nbPages: 0,
              page: 0,
              processingTimeMS: 0,
              hitsPerPage: 0,
              exhaustiveNbHits: false,
              query: '',
              params: '',
            })),
          });
        }
    
        return algoliaClient.search(requests);
      },
    };

    const search = instantsearch({
      indexName: 'minio',
      searchClient,
      initialUiState: {
        minio: {
          refinementList: {
            platform: [activePlatform],
          },
        }
      }
    });
    
    search.addWidgets([
      instantsearch.widgets.searchBox({
        container: "#searchbox",
        autofocus: true,
        showReset: false,
        showSubmit: false,
        showLoadingIndicator: false,
        placeholder: "Search Documentation"
      }),
      instantsearch.widgets.clearRefinements({
        container: '#clear-refinements',
      }),
      instantsearch.widgets.refinementList({
        container: '#brand-list',
        attribute: 'platform',
      }),
      instantsearch.widgets.hits({
        container: '#hits',
        templates: {
          item:function(data) {
            var returnString;
            var docUrl;
  
            if(data.hierarchy.lvl1 && data._highlightResult.hierarchy.lvl1.matchLevel === "full") {
              docUrl = data.url_without_anchor;
              returnString = `
                <i class="hit-icon">
                  ${icons.h1}
                </i>
                <div class="hit-title">${data._highlightResult.hierarchy.lvl1.value}</div>
              `
            }
            else if (data.hierarchy.lvl2 && data._highlightResult.hierarchy.lvl2.matchLevel === "full") {
              docUrl = data.url;
              returnString = `
                <i class="hit-icon">
                  ${icons.h2}
                </i>
                <div class="hit-title">${data._highlightResult.hierarchy.lvl2.value}</div>
                <div class="hit-label">${data.hierarchy.lvl1}</div>
              `
            }
            else if (data.hierarchy.lvl3 && data._highlightResult.hierarchy.lvl3.matchLevel === "full") {
              docUrl = data.url;
              returnString = `
                <i class="hit-icon">
                  ${icons.h3}
                </i>
                <div class="hit-title">${data._highlightResult.hierarchy.lvl3.value}</div>
                <div class="hit-label">${data.hierarchy.lvl1}</div>
              `
            }
            else if (data.hierarchy.lvl1 && data._snippetResult && data._snippetResult.content.matchLevel === "full") {
              docUrl = data.url;
              returnString = `
                <i class="hit-icon">
                  ${icons.content}
                </i>
                <div class="hit-title">${data._snippetResult.content.value}</div>
                <div class="hit-label">
                  ${data.hierarchy.lvl1}
                  <svg viewBox="0 0 24 24" fill="none" stroke-linecap="round" stroke-linejoin="round" class="block w-16 h-16 py-2 stroke-current stroke-2 flex-none text-grey-400-opacity-60"><polyline points="9 18 15 12 9 6"></polyline></svg>
                  ${data.hierarchy.lvl2}
                </div>
              `;
            }
            else {
              return false;
            }
  
            return `<a target="_blank" href="${docUrl}">${returnString}</a>`;
          }
        },
      }),
    ]);
    
    search.start();
  }

  initInstaSearch();

  searchToggleEl.forEach(item => {
    item.addEventListener('click', (e) => {
      // Modal UX
      e.preventDefault();

      root.classList.add('search-active');
      searchModalEl.classList.add("modal--active");

      setTimeout(() => {
        const instaSearchInputEl = document.querySelector(".ais-SearchBox-input");
        instaSearchInputEl.focus();
      });
    });
  });

  document.querySelector(".ais-SearchBox-reset").addEventListener("click", (e) => {
    searchModalEl.classList.remove("modal--active");
    root.classList.remove('search-active');
  });
});