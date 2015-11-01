require 'spec_helper'

describe User do
  it { should have_many :subscriptions }
  it { should have_many :services }
  it { should validate_presence_of :phone }
  it { should validate_presence_of :password }
  it { should validate_confirmation_of :password }

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

  describe '#send_out_code' do
    # it ""
  end
end
