class Service < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, through: :subscriptions

  #this class is just for registering new services
end
