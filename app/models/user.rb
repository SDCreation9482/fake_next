class User < ApplicationRecord
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  has_many :quests, dependent: :nullify

  enumerize :role, in: %i[member organizer admin], predicates: true, scope: true

  validates :name, presence: true
  validates :role, presence: true

  def display_name
    name.presence || email
  end
end
