// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })

// Custom command to login
Cypress.Commands.add('login', (email = 'test@example.com', password = 'password123') => {
  cy.visit('/customers/sign_in')
  cy.get('input[name="customer[email]"]').type(email)
  cy.get('input[name="customer[password]"]').type(password)
  cy.get('input[type="submit"]').click()
})

// Custom command to add a product to cart
Cypress.Commands.add('addProductToCart', (productIndex = 0) => {
  cy.visit('/store')
  cy.get('.card').eq(productIndex).click()
  cy.get('button').contains('Add to Cart').click()
})