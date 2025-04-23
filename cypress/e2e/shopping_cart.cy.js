// Tests for shopping cart and checkout functionality

describe('Shopping Cart and Checkout', () => {
  // Setup: Visit the site and log in before each test
  beforeEach(() => {
    // Visit the homepage
    cy.visit('/')
  })

  // Happy path: User can add items to cart
  it('allows adding products to cart', () => {
    // Visit the products page (store path in your app)
    cy.visit('/store')
    
    // Click on the first product card
    cy.get('.card').first().click()
    
    // Add to cart
    cy.get('button').contains('Add to Cart').click()
    
    // Verify success message
    cy.get('.alert-success').should('exist')
    
    // Go to cart page to verify item was added
    cy.get('a').contains('Cart').click()
    
    // Verify cart has items
    cy.get('table').should('exist')
    cy.get('tbody tr').should('have.length.at.least', 1)
  })

  // Happy path: User can view and modify cart
  it('allows viewing and modifying cart contents', () => {
    // Add a product to cart first
    cy.visit('/store')
    cy.get('.card').first().click()
    cy.get('button').contains('Add to Cart').click()
    
    // Go to cart page
    cy.get('a').contains('Cart').click()
    
    // Verify product is in cart
    cy.get('tbody tr').should('have.length.at.least', 1)
    
    // Remove item from cart (using the trash icon button)
    cy.get('.btn-outline-danger').first().click()
    
    // Handle the confirmation dialog if it appears
    cy.on('window:confirm', () => true)
    
    // Verify cart is empty
    cy.contains('Your cart is empty').should('be.visible')
  })

  // Happy path: User can complete checkout
  it('allows completing the checkout process', () => {
    // Add a product to cart first
    cy.visit('/store')
    cy.get('.card').first().click()
    cy.get('button').contains('Add to Cart').click()
    
    // Go to cart page
    cy.get('a').contains('Cart').click()
    
    // Proceed to checkout - look for a link or button that contains "Checkout"
    cy.get('a, button').contains(/Checkout|Proceed to Checkout/).click()
    
    // Fill in checkout form (based on your actual form)
    cy.get('input[name="customer[name]"]').type('Test User')
    cy.get('input[name="customer[email]"]').type('test@example.com')
    cy.get('input[name="customer[address]"]').type('123 Test St')
    cy.get('input[name="customer[city]"]').type('Test City')
    cy.get('select[name="customer[province_id]"]').select(1) // Select first province
    
    // Submit the form to review invoice - look for a button that contains "Review Invoice"
    cy.get('button').contains(/Review Invoice|Continue|Next/).click()
    
    // Verify we're on the invoice page
    cy.url().should('include', '/checkout')
    
    // Verify the invoice shows the order details
    cy.contains('Order Summary').should('be.visible')
  })

  // Unhappy path: Checkout fails with missing province
  it('shows validation errors during checkout with missing province', () => {
    // Add a product to cart first
    cy.visit('/store')
    cy.get('.card').first().click()
    cy.get('button').contains('Add to Cart').click()
    
    // Go to cart page
    cy.get('a').contains('Cart').click()
    
    // Proceed to checkout
    cy.get('a, button').contains(/Checkout|Proceed to Checkout/).click()
    
    // Fill in checkout form but leave province empty
    cy.get('input[name="customer[name]"]').type('Test User')
    cy.get('input[name="customer[email]"]').type('test@example.com')
    cy.get('input[name="customer[address]"]').type('123 Test St')
    cy.get('input[name="customer[city]"]').type('Test City')
    // Don't select province or select the prompt option
    cy.get('select[name="customer[province_id]"]').select(0)
    
    // Submit form
    cy.get('button').contains(/Review Invoice|Continue|Next/).click()
    
    // Verify some kind of error message exists
    cy.get('.alert, #error_explanation').should('exist')
  })

  // Unhappy path: Cannot checkout with empty cart
  it('prevents checkout with empty cart', () => {
    // Go directly to cart page with empty cart
    cy.visit('/cart')
    
    // Verify empty cart message
    cy.contains('Your cart is empty').should('be.visible')
    
    // Checkout button should not be visible with empty cart
    cy.contains('Checkout').should('not.exist')
  })
})