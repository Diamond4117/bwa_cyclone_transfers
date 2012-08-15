class User < ActiveRecord::Base
  after_create :create_remember_token
  #before_save :create_remember_token
  before_save { |user| user.email = email.downcase }
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :bankaccounts


  validates(:name, presence: true)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
	  	uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def self.search(params)
    puts params.inspect
    #find(:all, :conditions => "email = #{params[:search]}" )
    #User.all(:conditions => {:email = search })
    User.all(:conditions => "email = #{params[:search]}")
  end
  
  
  private
    def create_remember_token
      self.remember_token = self.id
      self.save
      #  proper session keys: self.remember_token = SecureRandom.urlsafe_base64
    end
end