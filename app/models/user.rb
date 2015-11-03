class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable,
         :lockable, :timeoutable, :omniauthable, omniauth_providers: [:facebook]

  def self.from_omniauth(auth)
    provider = auth.provider
    uid      = auth.uid

    User.where(provider: provider, uid: uid).first
  end
end
