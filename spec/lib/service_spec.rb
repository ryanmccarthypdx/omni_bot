require 'spec_helper'

describe Service do
  it { should have_many :subscriptions }
  it { should have_many :users }
end
