require 'spec_helper'

describe User do

  describe "sorting" do
    it "should sort by name" do
      a = [ Factory.create(:user, :login => "aa"),
            Factory.create(:user, :login => "cc"),
            Factory.create(:user, :login => "bb") ].sort!
      a.first.login.should == "aa"
      a.last.login.should == "cc"
    end
  end

  describe "scopes" do
    before :each do
      @user1 = Factory.create(:user)
      @user2 = Factory.create(:user)
      @course1 = Factory.create(:course)
      @course2 = Factory.create(:course)
      @ex1 = Factory.create(:exercise, :course => @course1,
                            :gdocs_sheet => "s1")
      @ex2 = Factory.create(:exercise, :course => @course2,
                            :gdocs_sheet => "s2")
      @sub1 = Factory.create(:submission, :user => @user1,
                            :course => @course1, :exercise => @ex1)
      @sub2 = Factory.create(:submission, :user => @user2,
                            :course => @course2, :exercise => @ex2)
      @avp1 = Factory.create(:available_point, :course => @course1,
                             :exercise => @ex1, :name => 'p1')
      @avp2 = Factory.create(:available_point, :course => @course2,
                             :exercise => @ex2, :name => 'p2')
      @awp1 = Factory.create(:awarded_point, :course => @course1,
                             :submission => @sub1, :user => @user1,
                             :name => 'p1')
      @awp2 = Factory.create(:awarded_point, :course => @course2,
                             :submission => @sub2, :user => @user2,
                             :name => 'p2')
    end

    it "course_students" do
      a = User.course_students(@course1)
      a.length.should == 1
      a.should include(@user1)

      a = User.course_students(@course2)
      a.length.should == 1
      a.should include(@user2)
    end

    it "course_sheet_students" do
      a = User.course_sheet_students(@course1, "s1")
      a.length.should == 1
      a.should include(@user1)

      a = User.course_sheet_students(@course2, "s2")
      a.length.should == 1
      a.should include(@user2)

      a = User.course_sheet_students(@course1, "lol")
      a.should be_empty

      a = User.course_sheet_students(@course2, "wtf")
      a.should be_empty
    end
  end

  describe "validation" do
    before :each do
      @params = {
        :login => 'matt',
        :password => 'horner',
        :email => 'matt@example.com'
      }
    end
  
    it "should succeed given a valid login, password and email" do
      User.new(@params).should have(0).errors_on(:login)
    end

    it "should fail without login" do
      @params.delete(:login)
      User.new(@params).should have(2).errors_on(:login)
    end
    
    it "should fail with a duplicate login" do
      User.create!(@params)
      @params[:email] = 'another@example.com'
      User.new(@params).should have(1).errors_on(:login)
    end
    
    it "should fail without email" do
      @params.delete(:email)
      User.new(@params).should have(1).error_on(:email)
    end
    
    it "should fail with duplicate email" do
      User.create!(@params)
      @params[:login] = 'another'
      User.new(@params).should have(1).errors_on(:email)
    end

    it "should fail with too short a login" do
      @params[:login] = 'a'
      User.new(@params).should have(1).error_on(:login)
    end

    it "should fail with too long a login" do
      @params[:login] = 'a'*21
      User.new(@params).should have(1).error_on(:login)
    end

    it "should succeed without a password for new records" do
      @params.delete(:password)
      User.new(@params).should be_valid
    end

    it "should be valid after it's reloaded" do
      User.create!(@params)
      user = User.find_by_login!(@params[:login])
      user.password.should be_nil
      user.should be_valid
      user.save!
    end
  end
  
  describe "destruction" do
    it "should destroy its submissions" do
      sub = Factory.create(:submission)
      sub.user.destroy
      Submission.find_by_id(sub.id).should be_nil
    end
    
    it "should destory its points" do
      point = Factory.create(:awarded_point)
      point.user.destroy
      AwardedPoint.find_by_id(point.id).should be_nil
    end
    
    it "should destroy any password reset key it has" do
      user = Factory.create(:user)
      key = PasswordResetKey.create!(:user => user)
      user.destroy
      PasswordResetKey.find_by_id(key.id).should be_nil
    end
    
    it "should destroy any user field values" do
      user = Factory.create(:user)
      value = UserFieldValue.create!(:field_name => 'foo', :user => user, :value => '')
      user.destroy
      UserFieldValue.find_by_id(value.id).should be_nil
    end
  end

  it "should allow authentication after modification" do
    created_user = User.create!(:login => "root",
                         :password => "qwerty123",
                         :email => "qwerty123@example.com",
                         :administrator => false)

    u = User.authenticate("root", "qwerty123")
    u.should eq(created_user)
    u.administrator = true
    u.save!

    u2 = User.authenticate("root", "qwerty123")
    u2.should_not be_nil

    created_user.destroy
  end

  it "should not allow authentication with an empty password" do
    User.create!(:login => 'user', :email => 'user@example.com')
    u = User.authenticate('user', '')
    u.should be_nil
  end

  it "should hash the password on create" do
    User.create!(:login => "instructor", :password => "ilikecookies", :email => 'instructor@example.com')
    user = User.find_by_login!("instructor")
    user.password.should be_nil
    user.password_hash.should_not be_nil
    user.should have_password("ilikecookies")
    user.should_not have_password("ihatecookies")
  end

  it "should hash the password on update" do
    User.create!(:login => "instructor", :password => "ihatecookies", :email => 'instructor@example.com')

    user = User.find_by_login!("instructor")
    user.password = 'ilikecookies'
    user.save!

    user = User.find_by_login!("instructor")
    user.password.should be_nil
    user.password_hash.should_not be_nil
    user.should have_password("ilikecookies")
    user.should_not have_password("ihatecookies")
  end

  it "should not reset the password when saved without changing the password" do
    user = User.create!(:login => "instructor", :password => "ihatecookies", :email => 'instructor@example.com')
    user.login = 'funny_person'
    user.save!

    user = User.find_by_login!('funny_person')
    user.should have_password('ihatecookies')
  end

  it "should allow authentication of administrators with a correct login/password" do
    user = User.create!(:login => "instructor", :password => "ilikecookies", :administrator => true, :email => 'instructor@example.com')
    User.authenticate("instructor", "ilikecookies").should eq(user)
    User.authenticate("instructor", "ihatecookies").should be_nil
    User.authenticate("root", "ilikecookies").should be_nil
  end
end
