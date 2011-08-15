class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i

  validates :name,      :presence => true,
                        :length => { :maximum => 50}

  validates :email,     :presence => true,
                        :format => { :with => email_regex },
                        :uniqueness => { :case_sensitive => false}

  validates :password,  :presence => true,
                        :confirmation => true,
                        :length => { :within => 4..40}

  before_save :encrypt_password
  
  has_many :microposts, :dependent => :destroy

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  def self.authenticate_with_salt(id, salt)
    user = find_by_id(id)
    (user && user.salt == salt) ? user : nil
  end
  
  def feed
    Micropost.where("user_id = ?", id)
  end

  private

  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end
