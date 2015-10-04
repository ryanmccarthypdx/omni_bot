require 'spec_helper'

describe User do
  it { should have_many :subscriptions }
  it { should have_many :services }
end
