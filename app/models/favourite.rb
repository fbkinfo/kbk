class Favourite < ActiveRecord::Base
  belongs_to :user
  belongs_to :entry, polymorphic: true

  scope :documents, -> { where(entry_type: 'Document') }
  scope :investigations, -> { where(entry_type: 'Investigation') }

  validates :user, presence: true
  validates :entry, presence: true
end
