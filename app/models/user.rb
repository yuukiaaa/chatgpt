class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  before_save { self.email = self.email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # emailのフォーマット検証の正規表現
  validates :name, presence:true, uniqueness:true, length:{ maximum: 10 }
  validates :email, presence:true, uniqueness:{ case_sensitive: false }, length:{ maximum: 255 }, format:{ with: VALID_EMAIL_REGEX }
  validates :password, presence:true, length:{ minimum: 6 }, allow_nil:true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def authenticated?(remember_token)
    return false if self.remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end