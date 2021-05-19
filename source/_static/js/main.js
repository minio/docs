window.addEventListener("DOMContentLoaded", (event) => {
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
		target === 'sidebar' ? $('body').removeClass('nav-toggled') : $('body').removeClass('sidebar-toggled');
		$('body').toggleClass(target + '-toggled');
	});
});
