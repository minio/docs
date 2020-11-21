window.addEventListener('DOMContentLoaded', (event) => {
   console.log('DOM fully loaded and parsed');

   var topic = document.getElementById('table-of-contents');

   if (topic != null) {
      document.getElementById('localtoc').appendChild(
         document.getElementById('table-of-contents')
      );

      console.log("moving local toc");
   }


   // There's probably a better way to refine what sections are shown on screen.
   // Experimenting with setting the `intersectionRatio` and such tends to stop
   // this from working, especially if the 'section' is really long. Not sure
   // how to resolve that.

   // Removing this from the logic flow until we have better / cleaner logic.

//    let options = {
//       rootMargin: '-100px 0px 0px -100px'
//    }

//    const observer = new IntersectionObserver(entries => {
//       entries.forEach(entry => {
//           const id = entry.target.getAttribute('id');
          
//           if (id == document.querySelector('.section[id]').getAttribute('id'))
//             return 0
//           if (entry.intersectionRatio > 0) {
              

//               pElement = document.querySelector(`#on-this-page li a[href="#${id}"]`).parentElement;
//               liElement = document.querySelector(`#on-this-page li a[href="#${id}"]`).parentElement.parentElement;
              
//               liElement.classList.add('active');
//               pElement.classList.add('active-p');

//               liElementParent = liElement.parentElement.parentElement

//               if (liElementParent.tagName == "LI") {
//                  //liElementParent.classList.remove("active")
//                  // Need to re-visit this logic
//               }

              

//           } else {
//               document.querySelector(`#on-this-page li a[href="#${id}"]`).parentElement.parentElement.classList.remove('active');
//               document.querySelector(`#on-this-page li a[href="#${id}"]`).parentElement.classList.remove('active-p');
//           }
//       });
//   },options);

//   // Track all sections that have an `id` applied
//   document.querySelectorAll('.section[id]').forEach((section) => {
//          observer.observe(section);
//   });

  const leftcolumn = document.querySelector('.left');
  const centercolumn = document.querySelector('.center');
  const rightcolumn = document.querySelector('.right');
  const button = document.querySelector('.sphinxsidebarbutton');
  const sidebarwrapper = document.querySelector('.sphinxsidebarwrapper');

  const sidebarToggle = document.querySelector('.sidebar-toggle');

  function toggleSidebar() {
      document.body.classList.toggle('sidebar-toggled');
  }

  sidebarToggle.addEventListener( "click", toggleSidebar );
});
