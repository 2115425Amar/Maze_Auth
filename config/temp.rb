# devise_for :users
# This sets up Devise authentication routes for the User model.
# It automatically generates routes for actions like sign up, login, logout, and password management.

# controllers: { registrations: 'users/registrations' }
# This tells Devise to use a custom controller for user registration.
# Instead of using Devise's default Devise::RegistrationsController,
# it will use Users::RegistrationsController (which should be located at app/controllers/users/registrations_controller.rb).
