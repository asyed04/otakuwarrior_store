// Hero Slideshow Functionality
console.log("Slideshow script loaded");

// Make handleSlideshow available globally
window.handleSlideshow = function() {
  console.log("Initializing slideshow");
  
  const slides = document.querySelectorAll('.hero-slide');
  const dots = document.querySelectorAll('.slideshow-dots .dot');
  
  console.log(`Found ${slides.length} slides and ${dots.length} dots`);
  
  if (slides.length === 0) {
    console.log("No slides found, exiting");
    return; // Exit if no slideshow on page
  }
  
  // Ensure first slide is active on initialization
  if (!document.querySelector('.hero-slide.active')) {
    slides[0].classList.add('active');
    if (dots.length > 0) {
      dots[0].classList.add('active');
    }
    console.log("Initialized first slide as active");
  }
  
  let currentSlide = Array.from(slides).findIndex(slide => slide.classList.contains('active'));
  if (currentSlide === -1) currentSlide = 0;
  
  let slideInterval;
  
  // Manual navigation with dots
  dots.forEach(dot => {
    dot.addEventListener('click', function() {
      const slideIndex = parseInt(this.getAttribute('data-slide'));
      console.log(`Dot clicked for slide ${slideIndex}`);
      goToSlide(slideIndex);
      resetInterval();
    });
  });
  
  // Start the automatic slideshow
  startSlideshow();
  
  function startSlideshow() {
    console.log("Starting slideshow interval");
    // Clear any existing interval first
    if (slideInterval) clearInterval(slideInterval);
    // Set new interval
    slideInterval = setInterval(nextSlide, 5000); // Change slide every 5 seconds
  }
  
  function nextSlide() {
    const nextIndex = (currentSlide + 1) % slides.length;
    console.log(`Auto-advancing to slide ${nextIndex}`);
    goToSlide(nextIndex);
  }
  
  function goToSlide(n) {
    console.log(`Going to slide ${n}, current is ${currentSlide}`);
    
    // Remove active class from current slide and dot
    slides[currentSlide].classList.remove('active');
    if (dots.length > currentSlide) {
      dots[currentSlide].classList.remove('active');
    }
    
    // Set new current slide
    currentSlide = n;
    
    // Add active class to new slide and dot
    slides[currentSlide].classList.add('active');
    if (dots.length > currentSlide) {
      dots[currentSlide].classList.add('active');
    }
  }
  
  function resetInterval() {
    console.log("Resetting interval");
    clearInterval(slideInterval);
    startSlideshow();
  }
};

// Initialize on page load - multiple event listeners for different scenarios
document.addEventListener('DOMContentLoaded', function() {
  console.log("DOMContentLoaded event fired");
  window.handleSlideshow();
});

document.addEventListener('turbo:load', function() {
  console.log("turbo:load event fired");
  window.handleSlideshow();
});

// Fallback - try to initialize after a short delay
setTimeout(function() {
  console.log("Fallback initialization");
  window.handleSlideshow();
}, 1000);

// Additional fallback for when images might be slow to load
window.addEventListener('load', function() {
  console.log("Window load event fired");
  window.handleSlideshow();
});