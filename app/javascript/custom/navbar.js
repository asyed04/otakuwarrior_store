// Navbar scroll effect
console.log("Navbar script loaded");

document.addEventListener('DOMContentLoaded', function() {
  console.log("Initializing navbar scroll effect");
  
  const navbar = document.querySelector('.navbar');
  
  if (!navbar) {
    console.log("Navbar not found");
    return;
  }
  
  // Function to handle scroll
  function handleScroll() {
    if (window.scrollY > 50) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  }
  
  // Add scroll event listener
  window.addEventListener('scroll', handleScroll);
  
  // Initial check
  handleScroll();
});

// Also initialize on Turbo navigation
document.addEventListener('turbo:load', function() {
  console.log("Turbo load - initializing navbar scroll effect");
  
  const navbar = document.querySelector('.navbar');
  
  if (!navbar) {
    console.log("Navbar not found after turbo load");
    return;
  }
  
  // Function to handle scroll
  function handleScroll() {
    if (window.scrollY > 50) {
      navbar.classList.add('scrolled');
    } else {
      navbar.classList.remove('scrolled');
    }
  }
  
  // Add scroll event listener
  window.addEventListener('scroll', handleScroll);
  
  // Initial check
  handleScroll();
});