require 'spec_helper'

describe Admin do
  before do
    @admin = FactoryGirl.create(:admin)
  end

  subject { @admin }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should be_valid }

  describe "when password is not present" do
    before do
      @admin = Admin.new(name: "Example Admin", email: "admin@example.com", password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @admin.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  it { should respond_to(:authenticate) }

  describe "with a password that's too short" do
    before { @admin.password = @admin.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @admin.save }
    let(:found_admin) { Admin.find_by(email: @admin.email) }

    describe "with valid password" do
      it { should eq found_admin.authenticate(@admin.password) }
    end

    describe "with invalid password" do
      let(:admin_for_invalid_password) { found_admin.authenticate("invalid") }

      it { should_not eq admin_for_invalid_password }
      specify { expect(admin_for_invalid_password).to be_false }
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @admin.email = mixed_case_email
      @admin.save
    expect(@admin.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "remember token" do
    before { @admin.save }

    # Equivalent;
    # it { expect(@admin.remember_token).not_to be_blank }
    its(:remember_token) { should_not be_blank }
  end

  describe "#send_password_reset" do
    it "generates a unique password_reset_token each time" do
      @admin.send_password_reset
      last_token = @admin.password_reset_token
      @admin.send_password_reset
      @admin.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      @admin.send_password_reset
      expect(@admin.password_reset_sent_at).to be_present
    end

    it "delivers email to admin" do
      @admin.send_password_reset
      expect(last_email.to).to include(@admin.email)
    end
  end
end

