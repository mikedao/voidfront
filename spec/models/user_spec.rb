require 'rails_helper'

RSpec.describe User, type: :model do
  # Basic validation tests using shoulda-matchers
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }

  # Factory test
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "is not valid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end
end