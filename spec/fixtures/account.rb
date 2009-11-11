class Account < ActiveRecord::Base
  cattr_accessor :current_account
  
  has_many :users
end