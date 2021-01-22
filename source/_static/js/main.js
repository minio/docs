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


	// Render navigation menu
	if($('#nav')[0]) {
		var navData = '/_static/data/nav.json';
		var nav = $('.nav');

		$.getJSON( navData, function(data) {
			var navToggle = $('<i class="toggle-icon toggle-icon--menu" />');
			navToggle.attr('data-toggle', 'nav');
			nav.after(navToggle);

			var navClose = $('<i />');
			navClose.addClass('toggle-icon toggle-icon--close');
			navClose.attr('data-toggle', 'nav');
			nav.append(navClose);

			$.each(data, function(nav, navValue) {
				var navElem = typeof navValue === 'object' ? '<span />' : '<a />';

				var navLink = $(navElem);
				navLink.addClass(nav === 'Docs' ? 'nav__item active' : 'nav__item');
				navLink.html('<span>' + nav + '</span>');

				if(navElem === '<a />') {
					navLink.attr('href', navValue);
				}
				else {
					var navDropdown = $('<div class="nav__dropdown" />');

					$.each(navValue, function(sub, subValue) {
						var navSub = $('<a />');
						navSub.addClass('nav__sub');
						navSub.text(sub);
						navSub.attr({
							'href': subValue.link,
							'target': '_blank',
							'rel': 'noreferrer'
						});
						navSub.append('<small>' + subValue.description + '</small>');
						navDropdown.append(navSub);
						navLink.append(navDropdown)
					});
				}
				
				$('#nav').append(navLink);
			});
			
		});
	}
});
