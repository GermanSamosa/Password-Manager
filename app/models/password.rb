class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords

  encrypts :username, deterministic: true
  encrypts :password

  validates :url, presence: true
  validates :username, presence: true
  validates :password, presence: true

  broadcasts_to ->(password) { "passwords" }, inserts_by: :prepend

  def shareable_users
    User.excluding(users)
  end

  def editable_by?(user)
    user_passwords.find_by(user:)&.editable?
  end

  def shareable_by?(user)
    user_passwords.find_by(user:)&.shareable?
  end

  def deleteable_by?(user)
    user_passwords.find_by(user:)&.deleteable?
  end
end
