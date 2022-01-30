Rails.application.load_tasks

RSpec.describe "users:create_admin" do
  let(:rake)      { Rake::Application.new }
  let(:task_path) { "/lib/tasks/users/create_admin" }

  it "creates a new admin user" do
    expect do
      Rake.application["users:create_admin"].invoke
    end.to change { User.count }.by(1)

    user = User.last
    expect(user).to be_admin
  end

  context "when an error occurs when saving the user" do
    before do
      # Mocking IO failure
      allow_any_instance_of(User).to receive(:save).and_return(false)
    end

    it "does not create the user" do
      expect do
        Rake.application["users:create_admin"].invoke
      end.not_to change { User.count }
    end
  end
end
