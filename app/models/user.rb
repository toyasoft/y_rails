class User < ApplicationRecord
  has_secure_password
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, length: { maximum: 255 }
  validates :password, length: { in: 8.20 }, format: { with: /(?=.*\d+.*)(?=.*[a-zA-Z]+.*).*[!@#%_,&~\\\^\?\|\/\*\.\-\+\$\(\)]+.*/, message: "半角英数字に記号を含めた文字にしてください" }, allow_blank: true
  validates :password, presence: true, on: :create

  attr_accessor :activation_token, :reset_token
  before_create :create_activation_digest
  before_save :downcase_email

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
