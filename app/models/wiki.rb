class Wiki < ActiveRecord::Base
  belongs_to :user

  default_scope { order('title ASC') }
  scope :visible_to, -> (user) { (user.premium? || user.admin?) ? all : where(:private => false) }

  validates :title, length: { minimum: 3 }, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :user, presence: true
end
