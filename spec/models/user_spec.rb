RSpec.describe User, type: :model do

  context "factories" do
    describe "build" do
      it "builds a valid user" do
        user = build :user

        expect(user).to be_valid
      end
    end

    describe "create" do
      it "creates a valid user" do
        expect { create :user }.to change { User.count }
      end
    end

    context "traits" do
      describe "invalid" do
        it "builds a invalid user" do
          user = build :user, :invalid

          expect(user).to be_invalid
        end
      end

      describe "admin" do
        it "creates an admin user" do
          user = create :user, :admin

          expect(user).to be_admin
        end
      end
    end
  end

  context "behaviours" do
    it { is_expected.to be_versioned }
  end

  context "validations" do
    context "uniqueness" do
      subject { create :user }

      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    # it { is_expected.to validate_format_of(:email).with(URI::MailTo::EMAIL_REGEXP) }
  end

  context "attributes" do
    it do
      roles = { admin: "admin", user: "user" }

      is_expected.to define_enum_for(:role)
        .with_values(roles)
        .backed_by_column_of_type(:enum)
    end
  end
end
