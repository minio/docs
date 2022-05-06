window.addEventListener("DOMContentLoaded", (event) => {
   // Detect parent iframe.
   // This is required to hide the navigation links when viewed via PathFactory for analytics purposes
   if (window.location !== window.parent.location) {
      document.body.classList.add('inside-iframe');
   }
   
   // Table of contents
	var topic = document.getElementById("table-of-contents");
	if (topic != null) {
		document
			.getElementById("localtoc")
			.appendChild(document.getElementById("table-of-contents"));
	}

   var l3 = document.getElementsByClassName("toctree-l3 current")
   var l2 = document.getElementsByClassName("toctree-l2 current")
   var l1 = document.getElementsByClassName("toctree-l1 current")

   if (l3.length > 0) {
      l3[0].classList.add("active");
      l2[0].classList.add("active-parent");
      l1[0].classList.add("active-parent");
   }
   else if (l2.length > 0 ) {
      l2[0].classList.add("active");
      l1[0].classList.add("active-parent");
   }
   else if (l1.length > 0 ) {
      l1[0].classList.add("active");
   }

	// Toggle Sidebars
	$('body').on('click', '[data-toggle]', function() {
		var target = $(this).attr('data-toggle');
		target === 'sidebar' ? $('body').removeClass('nav-active') : $('body').removeClass('sidebar-active');
		$('body').toggleClass(target + '-active');
	});

   renderPersonas();


});

function renderPersonas() {
   // This inserts the personas into the left-hand nav

   let operationPersona = document.createElement("span");
   operationPersona.innerHTML = "Operations";
   operationPersona.id = "operationsPersona";
   operationPersona.className = "persona";

   let administrationPersona = document.createElement("span");
   administrationPersona.innerHTML = "Administration";
   administrationPersona.id = "administrationPersona";
   administrationPersona.className = "persona";

   let developerPersona = document.createElement("span");
   developerPersona.innerHTML = "Developers";
   developerPersona.id = "developerPersona";
   developerPersona.className = "persona";

   let referencePersona = document.createElement("span");
   referencePersona.innerHTML = "Reference";
   referencePersona.id = "referencePersona";
   referencePersona.className = "persona";

   list = document.getElementsByClassName("toctree-l1");

   for (i=0; i<list.length; i++) {
      let page_title = list[i].childNodes[0].innerHTML;
      if (page_title === "Install and Deploy MinIO" || page_title === "Install the MinIO Operator") {
         list[i].insertAdjacentElement('beforebegin',operationPersona);
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
}