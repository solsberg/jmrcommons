require 'spec_helper'

describe User do
  subject { User.new(name: 'a_user', email: 'user@example.com', password: 'password', password_confirmation: 'password' ) }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :profile_answers }

  it { should be_valid }

  context "when name is missing" do
    before { subject.name = '' }
    it { should_not be_valid }
  end

  context "when name has spaces" do
    before { subject.name = 'a user' }
    it { should_not be_valid }
  end

  context "when name is too short" do
    before { subject.name = 'user' }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      user_with_same_name = subject.dup
      user_with_same_name.name.upcase!
      user_with_same_name.email = 'another@example.com'
      user_with_same_name.save
    end

    it { should_not be_valid }
  end

  context "when email is missing" do
    before { subject.email = '' }
    it { should_not be_valid }
  end

  describe "when email invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |address|
        subject.email = address
        expect(subject).not_to be_valid
      end
    end
  end

  describe "when email valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |address|
        subject.email = address
        expect(subject).to be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = subject.dup
      user_with_same_email.name = 'another_user'
      user_with_same_email.email.upcase!
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  it "should save email as all lower case" do
    mixed_case_email = "uSEr@EXaMple.COm"
    subject.email = mixed_case_email
    subject.save
    expect(subject.reload.email).to eq mixed_case_email.downcase
  end

  describe "when password does not match confirmation" do
    before { subject.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  context "when password is too short" do
    before { subject.password = subject.password_confirmation = 'passw' }
    it { should_not be_valid }
  end

  context "when password contains space" do
    before { subject.password = subject.password_confirmation = 'passwor d' }
    it { should_not be_valid }
  end

  describe "updating profile answers" do
    before { subject.save }
    context "when not responded to any questions" do
      it "should have no answers" do
        expect(subject.profile_answers).to be_empty
      end 
    end

    context "when responded to a question" do
      before { subject.respond_to(double(id: 1), "the answer") }
      it "should have the answer" do
        expect(subject.profile_answers.map(&:text)).to include "the answer"
      end 

      context "when changed the answer" do
        before { subject.respond_to(double(id: 1), "another answer") }
        
        it "should have the new answer" do
          expect(subject.profile_answers.map(&:text)).to include "another answer"
        end 

        it "should not have the old answer" do
          expect(subject.profile_answers.map(&:text)).not_to include "the answer"
        end 
      end
    end
  end
end
