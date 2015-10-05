require 'spec_helper'

describe User do
  it { should have_many :subscriptions }
  it { should have_many :services }
  it { should validate_presence_of :phone }

  describe '#create' do
    it "should validate uniqueness of phone" do
      User.create(phone: "1234")
      expect(User.create(phone: "1234").valid?).to eq false
    end
  end
end
