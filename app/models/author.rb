class Author < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :user

  def title
    name
  end
end
