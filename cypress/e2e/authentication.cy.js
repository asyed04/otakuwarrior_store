// Tests for user authentication (sign-up and login)

describe('Authentication', () => {
  // Happy path: User can sign up successfully
  it('allows a new user to sign up', () => {
    // Generate a unique email to avoid conflicts with existing users
    const uniqueEmail = `test${Date.now()}@example.com`
    const password = 'password123'

    cy.visit('/customers/sign_up')
    
    // Fill in the sign-up form
    cy.get('input[name="customer[name]"]').type('Test User')
    cy.get('input[name="customer[email]"]').type(uniqueEmail)
    cy.get('input[name="customer[address]"]').type('123 Test St')
    cy.get('input[name="customer[city]"]').type('Test City')
    cy.get('select[name="customer[province_id]"]').select(1) // Select first province
    cy.get('input[name="customer[password]"]').type(password)
    cy.get('input[name="customer[password_confirmation]"]').type(password)
    
    // Submit the form
    cy.get('input[type="submit"]').click()
    
    // Verify successful sign-up (redirected to home page or dashboard)
    cy.url().should('not.include', '/sign_up')
    
    // Verify success message is displayed (adjust based on your actual success message)
    cy.get('.alert-success').should('exist')
  })

  // Unhappy path: User cannot sign up with invalid data
  it('shows validation errors when sign-up form is invalid', () => {
    cy.visit('/customers/sign_up')
    
    // Submit empty form
    cy.get('input[type="submit"]').click()
    
    // Verify error messages exist (without checking specific text)
    cy.get('#error_explanation').should('exist')
    cy.get('#error_explanation li').should('exist')
    
    // Try with invalid email format
    cy.get('input[name="customer[email]"]').type('invalid-email')
    cy.get('input[name="customer[password]"]').type('short')
    cy.get('input[name="customer[password_confirmation]"]').type('short')
    cy.get('input[type="submit"]').click()
    
    // Verify error messages exist (without checking specific text)
    cy.get('#error_explanation').should('exist')
    cy.get('#error_explanation li').should('exist')
  })

  // Happy path: User can log in successfully
  it('allows existing user to log in', () => {
    // Use a known test user (you should create this user in your test database)
    const email = 'test@example.com'
    const password = 'password123'
    
    cy.visit('/customers/sign_in')
    
    // Fill in the login form
    cy.get('input[name="customer[email]"]').type(email)
    cy.get('input[name="customer[password]"]').type(password)
    
    // Submit the form
    cy.get('input[type="submit"]').click()
    
    // Verify successful login
    cy.url().should('not.include', '/sign_in')
    
    // Verify user is logged in (adjust based on your actual UI)
    cy.get('.alert-success').should('exist')
  })

  // Unhappy path: User cannot log in with incorrect credentials
  it('shows error message with incorrect login credentials', () => {
    cy.visit('/customers/sign_in')
    
    // Fill in the login form with incorrect credentials
    cy.get('input[name="customer[email]"]').type('wrong@example.com')
    cy.get('input[name="customer[password]"]').type('wrongpassword')
    
    // Submit the form
    cy.get('input[type="submit"]').click()
    
    // Verify error message
    cy.get('.alert').should('exist')
    cy.get('.alert').should('contain', 'Invalid Email or password')
  })
})