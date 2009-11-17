require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "AccountScopper" do
  # Homemade fixtures method that doesn't depend on active support
  fixtures :accounts, :users
  
  it "should proper set fixtures" do
    Account.find_by_name("Localhost").should == accounts(:localhost)
  end
  
  it "should have the current account initialized" do
    Account.current_account.should == accounts(:localhost)
  end
  
  it "should create user with account" do
    u = User.create
    u.account.should == accounts(:localhost)
  end
  
  it "should force account while creating new user" do
    u = User.create(:account_id => 2)
    u.account.should == accounts(:localhost)
  end

  it "should find user within account" do
    User.find(2).should == users(:marc)
  end

  it "should not find user having different account" do
    lambda { User.find(3) }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "should return only user from account" do
    User.all.each do |user|
      user.account.should == accounts(:localhost)
    end
  end
  
  it "should count only within account" do
    User.count.should == User.all.size
  end
  
  it "should delete all within account, not others" do
    User.delete_all
    User.count.should == 0
    Account.current_account = nil
    User.count.should > 0
  end
  
  it "should delete all if no account defined" do
    Account.current_account = nil
    User.delete_all
    User.count.should == 0
  end
  
  it "should not allow to destroy foreign users" do
    Account.current_account = nil
    user = User.find_by_name('Stephane')
    user.account.should_not == accounts(:localhost)
    Account.current_account = accounts(:localhost)
    user.destroy.should be_nil
  end
  
  it "should allow to destroy if not account" do
    Account.current_account = nil
    user = User.find_by_name('Stephane')
    user.destroy.should_not be_nil
  end
  
  it "should validates_uniqueness_of within account" do
    u = User.create(:name => "Seb")
    u.errors.on(:name).should == "has already been taken"
  end
  
  it "should not validates_uniqueness_of without scoping the current account" do
    u = User.create(:name => "Stephane")
    u.valid?.should be_true
  end
  
  it "should validates_global_uniqueness_of wihtout scoping the current account" do
    u = User.create(:login => "stephane")
    u.errors.on(:login).should == "has already been taken"
  end
end
