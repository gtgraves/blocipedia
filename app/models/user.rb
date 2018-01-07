class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :wikis
  has_many :collaborators

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  after_initialize { self.role ||= :standard }

  validates :name, length: { minimum: 1, maximum: 25 }, presence: true
  validates :email, length: { minimum: 3, maximum: 254 }

  enum role: [:standard, :admin, :premium]
end
