class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators
  has_many :users, through: :collaborators

  default_scope { order('title ASC') }
  scope :visible_to, -> (user) { (user.premium? || user.admin?) ? all : where(:private => false) }

  validates :title, length: { minimum: 2 }, presence: true
  validates :body, length: { minimum: 15 }, presence: true
  validates :user, presence: true
end
