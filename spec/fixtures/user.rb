class User < ActiveRecord::Base
  belongs_to :account
  
  validates_uniqueness_of :name
  validates_global_uniqueness_of :login
end