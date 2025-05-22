 // Import Turbo
import "@hotwired/turbo-rails"

// Import Rails UJS for handling CSRF tokens and other Rails-specific JS
import * as Rails from "@rails/ujs"

// Import controllers
import "controllers"

// Import custom scripts
import "./custom/slideshow"
import "./custom/flash_messages"
import "./custom/cart_quantity"
import "./custom/navbar"

// Start Rails UJS
document.addEventListener("DOMContentLoaded", function() {
  Rails.start();
  console.log("Rails UJS started");
  
  // Ensure slideshow is initialized
  console.log("Manually initializing slideshow from application.js");
  if (typeof handleSlideshow === 'function') {
    handleSlideshow();
  }
});
