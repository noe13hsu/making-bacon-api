require 'rails_helper'

RSpec.describe Budget, type: :model do
  it { should belong_to(:user) }

  it { should validate_presence_of(:amount) }
  it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
end
