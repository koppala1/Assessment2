class DataModel < ApplicationRecord
  validates :name, presence: true
  validates :data, presence: true
  validate :valid_data_format
  private

  def valid_data_format
    errors.add(:data, 'must be a valid JSON string') unless valid_json?(data)
  end

  def valid_json?(json_string)
    JSON.parse(json_string)
    true
  rescue JSON::ParserError => e
    false
  end
end
