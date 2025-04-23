# Cypress End-to-End Tests for Otaku Warrior Store

This directory contains end-to-end tests for the Otaku Warrior Store application using Cypress.

## Test Coverage

The tests cover two main features:

1. **Authentication (Sign-up/Login)**
   - Happy path: Successful sign-up
   - Unhappy path: Validation errors during sign-up
   - Happy path: Successful login
   - Unhappy path: Login with incorrect credentials

2. **Shopping Cart and Checkout**
   - Happy path: Adding products to cart
   - Happy path: Viewing and modifying cart contents
   - Happy path: Completing the checkout process
   - Unhappy path: Checkout with missing required fields
   - Unhappy path: Attempting to checkout with an empty cart

## Running the Tests

### Prerequisites

1. Make sure your Rails server is running:
   ```
   rails server
   ```

2. Make sure you have test data in your database:
   - At least one product
   - Provinces for tax calculation
   - A test user account (for login tests)

### Running Tests in Cypress UI

```
npx cypress open
```

This will open the Cypress Test Runner where you can select which tests to run.

### Running Tests in Headless Mode

```
npx cypress run
```

This will run all tests in headless mode and generate a report.

## Test User Setup

For the login tests to work, you need to create a test user with the following credentials:

- Email: test@example.com
- Password: password123

You can create this user through the Rails console:

```ruby
Customer.create!(
  email: 'test@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  province_id: Province.first.id
)
```

## Troubleshooting

If tests are failing, check the following:

1. Is your Rails server running?
2. Does your database have the necessary test data?
3. Are the CSS selectors in the tests matching your actual HTML?
4. Are the form field names correct?

## Customizing Tests

You may need to adjust the selectors and assertions in the tests to match your specific implementation. Key areas to check:

- Form field names
- CSS classes for elements
- Success/error message text
- URLs and routes