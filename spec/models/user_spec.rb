require 'spec_helper'

describe User do
  it { should have_many :subscriptions }
  it { should have_many :services }
  it { should validate_presence_of :phone }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of :password }

  context "without a saved user" do
    let(:user) { User.new(password: "password") }

    describe '#create' do
      it "should invalidate when non-unique phone number is passed in" do
        User.create(phone: ENV['KNOWN_REAL_CELL_NUMBER'], password: "foobar")
        user.phone = ENV['KNOWN_REAL_CELL_NUMBER']
        expect(user.valid?).to eq false
      end

      it "should invalidate when a non-US number is passed in" do
        canadian_number = "13065692323"
        user.phone = canadian_number
        expect(user.valid?).to eq false
      end

      it "should invalidate when a non-mobile number is passed in" do
        user.phone = ENV['REAL_LANDLINE_NUMBER']
        expect(user.valid?).to eq false
      end

      it "should validate when a mobile, US-based number is passed in" do
        user.phone = ENV['KNOWN_REAL_CELL_NUMBER']
        expect(user.valid?).to eq true
      end

      it "should call send_out_new_code after_create" do
        user.phone = ENV['KNOWN_REAL_CELL_NUMBER']
        expect(user).to receive(:send_out_new_code)
        user.save
      end
    end
  end

  context "with a valid, saved user" do

    let(:user) { FactoryGirl.create(:user) }

    describe '#send_out_code' do
      context "with too many confirmations" do

        before do
          user.total_confirmations = 5
        end

        it "should raise an error if too many confirmation attempts have happened" do
          user.total_confirmations = 5
          expect{ user.send_out_new_code }.to raise_error(OmniBotError)
        end

        it "should increment the total_confirmations" do
          begin
            user.send_out_new_code
          rescue
            expect(user.total_confirmations).to eq 6
          end
        end

        it "should not set a new confirmation code" do
          original_code = user.confirmation_code
          expect(user).to receive(:set_new_confirmation_code).exactly(0).times
          begin
            user.send_out_new_code
          rescue
            expect(user.confirmation_code).to eq original_code
          end
        end
      end

      it "should increment total_confirmations by one" do
        original_confirmations = user.total_confirmations
        user.send_out_new_code
        expect(user.total_confirmations).to eq(original_confirmations + 1)
      end

      it "should set and save a new confirmation code and time" do
        user.send_out_new_code
        expect(user.confirmation_code.length).to eq 6
        expect(user.confirmation_code.class).to eq String
        expect(user.confirmation_time.class).to eq Time
      end

      it "should reset a new code when called the second time" do
        user.send_out_new_code
        original_code = user.confirmation_code
        user.send_out_new_code
        expect(user.confirmation_code.eql?(original_code)).to eq false
      end

      it "should reset the confirmation_time" do
        user.send_out_new_code
        original_time = user.confirmation_time
        user.send_out_new_code
        expect(user.confirmation_time.eql?(original_time)).to eq false
      end

      it "should generate a new message" do
        expect(user).to receive(:send_confirmation_message)
        user.send_out_new_code
      end
    end
  end
end
