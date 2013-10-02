class Organization < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :investigations, through: :documents
  has_many :documents

  def cache_investigations_counter!
    update_attribute(:investigations_count, investigations.count)
  end
end
