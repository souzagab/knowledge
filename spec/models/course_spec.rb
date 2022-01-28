RSpec.describe Course, type: :model do

  context "factories" do
    # TODO: Create a shared_example for testing factories
    describe "build" do
      it "builds a valid resource" do
        course = build :course

        expect(course).to be_valid
      end
    end

    describe "create" do
      it "creates a valid course" do
        expect { create :course }.to change { Course.count }
      end
    end

    context "traits" do
      describe "invalid" do
        it "builds a invalid course" do
          course = build :course, :invalid

          expect(course).to be_invalid
        end
      end
    end
  end

  context "behaviours" do
    it { is_expected.to be_versioned }
  end

  context "relations" do
    it { is_expected.to have_many(:enrollments) }
    it { is_expected.to have_many(:attendees).through(:enrollments).source(:user) }

    it { is_expected.to have_many(:contents) }

    it { is_expected.to have_one_attached :thumbnail }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
  end
end
