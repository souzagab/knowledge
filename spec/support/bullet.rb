RSpec.configure do |config|
  config.around do |example|
    # config tag to not use bullet
    without_bullet = example.metadata[:without_bullet]

    Bullet.enable = false if without_bullet

    example.run

    Bullet.enable = true if without_bullet
  end
end
