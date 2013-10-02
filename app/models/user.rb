class User < ActiveRecord::Base
  extend Enumerize

  enumerize :role, in: [:lawyer, :admin], default: :lawyer, predicates: true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :lockable, :recoverable

  validates :name, presence: true, uniqueness: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true

  has_one :author
  has_many :documents
  has_many :favourites
  has_many :investigations

  after_create :create_author

  def active_for_authentication?
    super && !blocked?
  end

  private

  def create_author
    Author.create!(name: name, user_id: id)
  end
end
