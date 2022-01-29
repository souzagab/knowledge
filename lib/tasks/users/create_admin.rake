# Task for creating the first admin user to the system
# Use:
# bin/rails users:create_admin
#
namespace :users do
  task :create_admin do
    # TODO: Expand task to allow the use of dynamic args (with optparse)
    password = SecureRandom.hex(4)

    User.create! name: "Administrator", email: "admin@knowledge.com", password: password, role: :admin

    puts """
    ===================================================

      User created!

      email:    admin@knowledge.com
      password: #{password}

    ===================================================
    """
  end
end
