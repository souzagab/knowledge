RSpec.describe Enrollment, type: :model do
  context "factories" do
    # TODO: Create a shared_example for testing factories
    describe "build" do
      it "builds a valid resource" do
        enrollment = build :enrollment

        expect(enrollment).to be_valid
      end
    end

    describe "create" do
      it "creates a valid enrollment" do
        expect { create :enrollment }.to change { Enrollment.count }
      end
    end

    context "traits" do
      describe "invalid" do
        it "builds a invalid enrollment" do
          enrollment = build :enrollment, :invalid

          expect(enrollment).to be_invalid
        end
      end
    end
  end

  context "behaviours" do
    it { is_expected.to be_versioned }
  end

  context "relations" do
    it { is_expected.to belong_to :course }
    it { is_expected.to belong_to :user }
  end

  context "validations" do
    context "uniqueness" do
      subject { create :enrollment }

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:course_id) }
    end
  end
end
