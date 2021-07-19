require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }
  it { should have_many(:categories).dependent(:destroy) }
  it { should have_one(:budget).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }

  describe 'validate uniqueness of email' do
    subject { FactoryBot.build(:user) }
    it { should validate_uniqueness_of(:email) }
  end
end
