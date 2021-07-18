require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:transactions).dependent(:destroy) }
  
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:category_type) }
end
