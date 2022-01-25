RSpec.describe Course, type: :model do

  context "factories" do
    # TODO: Create a shared_example for testing factories
    describe "build" do
      it "builds a valid resource" do
        user = build :course

        expect(user).to be_valid
      end
    end

    describe "create" do
      it "creates a valid user" do
        expect { create :course }.to change { Course.count }
      end
    end

    context "traits" do
      describe "invalid" do
        it "builds a invalid user" do
          user = build :course, :invalid

          expect(user).to be_invalid
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

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end

end
