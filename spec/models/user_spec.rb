require 'spec_helper'

describe User do
  it { should have_many :subscriptions }
  it { should have_many :services }
  it { should validate_presence_of :phone }
  it { should validate_confirmation_of :password }

  describe '#create' do
    it "should invalidate when non-unique phone number is passed in" do
      User.create(phone: ENV['KNOWN_REAL_CELL_NUMBER'])
      expect(User.create(phone: ENV['KNOWN_REAL_CELL_NUMBER']).valid?).to eq false
    end

    it "should invalidate when a non-US number is passed in" do
      canadian_number = "13065692323"
      expect(User.create(phone: canadian_number).valid?).to eq false
    end

    it "should invalidate when a non-mobile number is passed in" do
      expect(User.create(phone: ENV['CANADIAN_CELL_NUMBER']).valid?).to eq false
    end

    it "should validate when a mobile, US-based number is passed in" do
      expect(User.create(phone: ENV['KNOWN_REAL_CELL_NUMBER']).valid?).to eq true
    end
  end
end
