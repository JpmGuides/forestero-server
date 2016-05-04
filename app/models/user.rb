class User < ApplicationRecord
  validates_confirmation_of :password

  # Include default devise modules. Others available are:
  # :registerable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable,
         :lockable, :invitable
end
