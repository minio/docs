window.addEventListener("DOMContentLoaded", (event) => {
	var topic = document.getElementById("table-of-contents");
	if (topic != null) {
		document
			.getElementById("localtoc")
			.appendChild(document.getElementById("table-of-contents"));
	}

	// Toggle Sidebars
	$('body').on('click', '[data-toggle]', function() {
		var target = $(this).attr('data-toggle');
		target === 'sidebar' ? $('body').removeClass('nav-toggled') : $('body').removeClass('sidebar-toggled');
		$('body').toggleClass(target + '-toggled');
	});
});
