# Task for creating the first admin user to the system
# Use:
# bin/rails users:create_admin
#
namespace :users do
  task create_admin: :environment do
    # TODO: Expand task to allow the use of dynamic args (with optparse)
    password = SecureRandom.hex(16)

    user = User.create! name: "Administrator",
                        email: "#{SecureRandom.hex(4)}@knowledge.com",
                        password: password,
                        role: :admin

    if user.persisted?
      puts """
      ===================================================

        User created!

        email:    #{user.email}
        password: #{password}

      ===================================================
      """
    end

  rescue => error # rubocop:disable Style/RescueStandardError
    puts "Admin not created!"

    puts error
  end
end
