document.addEventListener('turbo:load', function() {
  console.log('Cart quantity buttons JS loaded (turbo:load)');
  document.querySelectorAll('.quantity-input-container').forEach(function(container) {
    var input = container.querySelector('.cart-quantity-input');
    var btnUp = container.querySelector('.quantity-btn-up');
    var btnDown = container.querySelector('.quantity-btn-down');
    var form = container.closest('form');

    if (input && btnUp && btnDown && form) {
      console.log('Attaching event listeners for quantity buttons');
      btnUp.addEventListener('click', function() {
        var currentValue = parseInt(input.value) || 1;
        input.value = currentValue + 1;
        form.submit();
      });

      btnDown.addEventListener('click', function() {
        var currentValue = parseInt(input.value) || 1;
        if (currentValue > 1) {
          input.value = currentValue - 1;
          form.submit();
        }
      });
    }
  });
});
