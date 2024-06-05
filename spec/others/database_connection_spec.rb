# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Database connection' do
  it 'can connect to the database' do
    expect { ActiveRecord::Base.connection.execute('SELECT 1') }.not_to raise_error
  end
end
