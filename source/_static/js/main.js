window.addEventListener('DOMContentLoaded', (event) => {
   console.log('DOM fully loaded and parsed');

   var topic = document.getElementById('on-this-page');

   if (topic != null) {
      document.getElementById('localtoc').appendChild(
         document.getElementById('on-this-page')
      );

      console.log("moving local toc");
   }

   let options = {
      root: document.querySelector('#scrollArea'),
      rootMargin: '-100px 0px 0px 0px'
   }

   const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
          const id = entry.target.getAttribute('id');
          console.log("entry is " + id + " Ratio is " + entry.intersectionRatio)
          console.log(entry.rootBounds)
          
          if (id == document.querySelector('.section[id]').getAttribute('id'))
            return 0
          if (entry.intersectionRatio > 0) {
              
              liElement = document.querySelector(`#on-this-page li a[href="#${id}"]`).parentElement.parentElement;
              
              liElement.classList.add('active');

              liElementParent = liElement.parentElement.parentElement

              if (liElementParent.tagName == "LI") {
                 liElementParent.classList.remove("active")
              }

              

          } else {
              document.querySelector(`#on-this-page li a[href="#${id}"]`).parentElement.parentElement.classList.remove('active');
          }
      });
  },options);

  // Track all sections that have an `id` applied
  document.querySelectorAll('.section[id]').forEach((section) => {
         observer.observe(section);
  });

     

});
