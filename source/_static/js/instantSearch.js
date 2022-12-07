window.addEventListener("DOMContentLoaded", () => {
  const searchToggleEl = document.querySelectorAll(".search-toggle");
  const searchModalEl = document.getElementById("search");
  const root = document.documentElement;

  // Get the current doc platform
  const activePlatform = document
    .getElementsByTagName("meta")
    ["docsearch:platform"].getAttribute("content");

  // SVG Icons
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
                </svg>`,
    noResult: `<svg width="56" height="56">
                  <path d="M44.26 12.728c5.903 8.844 5.017 20.636-2.951 28.595h0L54 54 41.309 41.324c-7.722 7.709-19.803 8.94-28.924 2.948m-6.493-6.486C-.178 28.73.95 16.663 8.593 8.887S28.295-.24 37.472 5.653M4.415 51.642L51.639 4.474" stroke="currentColor" stroke-width="2.5" fill="none" stroke-linecap="round" stroke-linejoin="round" />
                </svg>`,
    chevron: `<svg viewBox="0 0 24 24" fill="none" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="9 18 15 12 9 6"></polyline>
                </svg>`,
  };

  // Template for empty search results
  function noResultTemplate(query) {
    return `<div class="search__empty">
              ${icons.noResult}</br>
              No results have been found for <span>${query}</span>.</br>
              Please rephrase your query!
            </div>`;
  }

  // Detect macOS
  function isMac() {
    return navigator.platform.toUpperCase().indexOf("MAC") >= 0;
  }

  // Algolia credintials
  const algoliaClient = algoliasearch(
    "E1CSOK3UC2",
    "6bc246d81fd3b79f51cf88f0b2481bac"
  );

  // By default, Instantsearch will display the latest hits even without a query.
  // As per our design, we don't need this behaviour.
  // So, use promise to conditionally render the search results.
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
            query: "",
            params: "",
          })),
        });
      }

      return algoliaClient.search(requests);
    },
  };

  // Init Instantsearch
  const search = instantsearch({
    indexName: "minio",
    searchClient,
    initialUiState: {
      minio: {
        refinementList: {
          platform: [activePlatform],
        },
      },
    },
  });

  // Add Instanstsearch widgets
  search.addWidgets([
    instantsearch.widgets.searchBox({
      container: "#search-box",
      autofocus: true,
      showReset: false,
      showSubmit: false,
      placeholder: "Search Documentation",
      cssClasses: {
        input: "search__input",
        reset: "search__reset",
        form: "search__form",
        loadingIndicator: "search__loading",
      },
      queryHook(query, search) {
        if (query !== "") {
          // Make search modal active
          searchModalEl.classList.add("search--focused");

          // Clear the filters and select the active platform
          setTimeout(() => {
            const activeFilterEl = document.querySelector(
              ".search__filters__checkbox[value='" + activePlatform + "']"
            );

            if (activeFilterEl && !activeFilterEl.checked) {
              activeFilterEl.click();
            }
          }, 50);
        } else {
          // Clear the filters
          clearRefinements();
        }

        // Fire the search
        search(query);
      },
    }),
    instantsearch.widgets.poweredBy({
      container: "#search-powered-by",
      cssClasses: {
        link: "search__powered-by",
      },
    }),
    instantsearch.widgets.refinementList({
      container: "#search-filters",
      attribute: "platform",
      cssClasses: {
        root: "search__filters",
        noRefinementRoot: "search__filters--empty",
        list: "search__filters__list",
        labelText: "search__filters__label",
        checkbox: "search__filters__checkbox",
        count: "search__filters__count",
      },
    }),
    instantsearch.widgets.clearRefinements({
      container: "#search-clear",
      cssClasses: {
        button: "search-clear__btn",
      },
    }),
    instantsearch.widgets.hits({
      container: "#search-results",
      cssClasses: {
        root: "search__hits",
        emptyRoot: "search__hits--empty",
        list: "search__hits__list",
        item: "search__hits__item",
      },
      templates: {
        empty: function (data) {
          return data.query !== "" ? noResultTemplate(data.query) : "";
        },
        item: function (data) {
          var returnString;
          var docUrl;
          var refinedLenth =
            search.renderState.minio.refinementList.platform.items.filter(
              (x) => x.isRefined
            ).length;

          if (refinedLenth !== 1) {
            searchModalEl.classList.add("search--show-platform");
          } else {
            searchModalEl.classList.remove("search--show-platform");
          }

          // If the query is a full-match of a lvl1 title,
          // display only the h1.
          if (
            data.hierarchy.lvl1 &&
            data._highlightResult.hierarchy.lvl1.matchLevel === "full"
          ) {
            docUrl = data.url_without_anchor;
            returnString = `
                  <i class="search__hits__icon">
                    ${icons.h1}
                  </i>
                  <div class="search__hits__title">${data._highlightResult.hierarchy.lvl1.value}</div>
                  <div class="search__hits__platform">${data.platform}</div>
                `;
          }
          // If the query is a full-match of a lvl2 title,
          // display h2 as the title and h1 as the sub-text.
          else if (
            data.hierarchy.lvl2 &&
            data._highlightResult.hierarchy.lvl2.matchLevel === "full"
          ) {
            docUrl = data.url;
            returnString = `
                  <i class="search__hits__icon">
                    ${icons.h2}
                  </i>
                  <div class="search__hits__title">${data._highlightResult.hierarchy.lvl2.value}</div>
                  <div class="search__hits__label">
                    <div class="search__hits__platform">${data.platform}</div>
                    ${data.hierarchy.lvl1}
                  </div>
                `;
          }
          // If the query is a full-match of a lvl3 title,
          // display h3 as the title and h1, h2 as the sub-text.
          else if (
            data.hierarchy.lvl3 &&
            data._highlightResult.hierarchy.lvl3.matchLevel === "full"
          ) {
            docUrl = data.url;
            returnString = `
                  <i class="search__hits__icon">
                    ${icons.h3}
                  </i>
                  <div class="search__hits__title">${data._highlightResult.hierarchy.lvl3.value}</div>
                  <div class="search__hits__label">
                    <div class="search__hits__platform">${data.platform}</div>
                    ${data.hierarchy.lvl1}
                  </div>
                `;
          }
          // If the query is a full-match of any content,
          // display the content as the title and h1, h2? and h3? as the sub-text.
          else if (
            data.hierarchy.lvl1 &&
            data._snippetResult &&
            data._snippetResult.content.matchLevel !== "none"
          ) {
            docUrl = data.url;
            returnString = `
                  <i class="search__hits__icon">
                    ${icons.content}
                  </i>
                  <div class="search__hits__title">${
                    data._snippetResult.content.value
                  }</div>
                  <div class="search__hits__label">
                    <div class="search__hits__platform">${data.platform}</div>
                    <span>${data.hierarchy.lvl1}</span>
                    ${
                      data.hierarchy.lvl2
                        ? `${icons.chevron}` +
                          `<span>${data.hierarchy.lvl2}</span>`
                        : ""
                    }
                    ${
                      data.hierarchy.lvl3
                        ? `${icons.chevron}` +
                          `<span>${data.hierarchy.lvl3}</span>`
                        : ""
                    }
                  </div>
                `;
          } else {
            return false;
          }

          return `<a target="_blank" rel="noreferrer noopener" href="${docUrl}">
                    ${returnString}
                  </a>`;
        },
      },
    }),
  ]);

  // Function to clear search field and filters
  function clearRefinements(trigger) {
    const filtersClearEl = document.querySelector(
      "#search-clear .search-clear__btn"
    );
    filtersClearEl?.click();

    const removeClasses = function () {
      root.classList.remove("locked");
      searchModalEl.classList.remove("search--active", "search--focused");
    };

    if (trigger === "btn") {
      removeClasses();
    } else {
      if (!root.classList.contains("read-mode")) {
        removeClasses();
      }
    }
  }

  // Function to close and reset the search modal
  function closeSearchModal() {
    const searchResetEl = document.querySelector(".search__reset");

    setTimeout(() => {
      searchResetEl.click();
    });
  }

  // Toggle search modal on read-mode and mobile
  // on search icon click.
  searchToggleEl.forEach((item) => {
    item.addEventListener("click", (e) => {
      e.preventDefault();

      root.classList.add("locked");
      searchModalEl.classList.add("search--active");

      setTimeout(() => {
        const instaSearchInputEl = document.querySelector(".search__input");
        instaSearchInputEl.focus();
      });
    });
  });

  // Clear the filters on x click
  document.addEventListener("click", (e) => {
    if(e.target.classList.contains("search__reset")) {
      clearRefinements("btn");
    }
  }, false);

  // Close the search modal on outside click
  document.addEventListener("pointerdown", function (e) {
    if (e.target.id === "search") {
      closeSearchModal();
    }
  })
  

  // Keyboard events
  document.addEventListener(
    "keydown",
    (e) => {
      // Close the search on esc key press
      if (e.key === "Escape") {
        if(searchModalEl.classList.contains("search--focused") 
        || searchModalEl.classList.contains("search--active")) {
          closeSearchModal();
        }
      }

      // Focus the search input on "Meta + K" key press
      const searchInputEl = document.querySelector(".search__input");
      var metaKey = isMac() ? e.metaKey : e.ctrlKey;
      if (metaKey && e.key === "k") {
        if (root.classList.contains("read-mode")) {
          searchModalEl.classList.add("search--active");
          searchInputEl.focus();
        }

        searchInputEl.focus();
        window.scrollTo(0, 0);
      }
    },
    false
  );

  // Start the search
  search.start();

  // --------------------------------------------------
  // Trigger search on keyboard shortcut
  // meta + k
  // --------------------------------------------------
  const searchEl = document.getElementById("search-box");
  const searchToggleBtnEl = document.querySelector(".search-toggle--keyboard");

  if (searchEl) {
    var metaKey = isMac() ? "⌘K" : "Ctrl+K";

    [searchEl, searchToggleBtnEl].forEach((item) => {
      item.insertAdjacentHTML("beforeend", `<i class="search-meta-key">${metaKey}</i>`);
    });
  }
});
