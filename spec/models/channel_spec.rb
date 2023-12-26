require 'rails_helper'

RSpec.describe Channel, type: :model do
  it { should validate_presence_of(:client_id) }
  it { should validate_presence_of(:device_id) }
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:path) }
  it { should validate_length_of(:category).is_at_least(3) }
  it { should validate_length_of(:path).is_at_least(3) }

  describe '.ransackable_attributes' do
    it 'returns the correct attributes' do
      expected_attributes = %w[array_info category client_id color created_at device_id id id_value label obs path platform previous_state range tipo updated_at]
      expect(Channel.ransackable_attributes).to eq(expected_attributes)
    end
  end
end
