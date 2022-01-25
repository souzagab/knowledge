RSpec.describe Attendee, type: :model do
  context "factories" do
    # TODO: Create a shared_example for testing factories
    describe "build" do
      it "builds a valid resource" do
        attendee = build :attendee

        expect(attendee).to be_valid
      end
    end

    describe "create" do
      it "creates a valid attendee" do
        expect { create :attendee }.to change { Attendee.count }
      end
    end

    context "traits" do
      describe "invalid" do
        it "builds a invalid attendee" do
          attendee = build :attendee, :invalid

          expect(attendee).to be_invalid
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

end
