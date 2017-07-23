class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :name, length: { minimum: 1, maximum: 25 }, presence: true
  validates :email, length: { minimum: 3, maximum: 254 }
end
