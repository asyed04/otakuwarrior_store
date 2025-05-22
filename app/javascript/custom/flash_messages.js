// Flash messages auto-fade functionality
document.addEventListener("DOMContentLoaded", function() {
  // Target all flash messages (both notice and alert)
  const flashMessages = document.querySelectorAll('.alert-success, .alert-danger');
  
  // Set timeout for each flash message to fade out
  flashMessages.forEach(function(message) {
    // Start the fade out after 5 seconds (5000ms)
    setTimeout(function() {
      // Add a fade-out class that will trigger the CSS transition
      message.classList.add('fade-out');
      
      // After the transition completes, remove the element
      message.addEventListener('transitionend', function() {
        message.remove();
      });
    }, 5000);
  });
});