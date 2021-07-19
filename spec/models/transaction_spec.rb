require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { should belong_to(:category) }
  
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:amount) }
  it { should validate_presence_of(:date) }
end
