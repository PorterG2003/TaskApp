class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :google_uid, presence: true, uniqueness: true
  
  def self.from_omniauth(auth_hash)
    user_data = auth_hash.info
    credentials = auth_hash.credentials
    
    user = find_or_create_by(google_uid: auth_hash.uid) do |u|
      u.email = user_data.email
      u.name = user_data.name
    end
    
    # Update tokens on each login
    user.update!(
      google_token: credentials.token,
      google_refresh_token: credentials.refresh_token || user.google_refresh_token
    )
    
    user
  end
  
  def display_name
    name || email.split('@').first
  end
end
