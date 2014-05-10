class Admin < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # Regex disallows double dots in email addresses.
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitve: false }
  has_secure_password
  validates :password, length: { minimum: 6 },
            # :on => [:create, :update_password]
            :if => :password # only validate if password changed!
  before_create :create_remember_token

  def Admin.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Admin.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    AdminMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      # self[column] = SecureRandom.urlsafe_base64
      self.update_column(column, SecureRandom.urlsafe_base64)
    end if Admin.exists?(column => self[column])
  end

  private

    def create_remember_token
      self.remember_token = Admin.encrypt(Admin.new_remember_token)
    end
end