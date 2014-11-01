class RailsUser < ActiveRecord::Base

	has_many :moods
  has_many :sleeps
  has_many :self_cares
  has_many :journals

  # User is free account, Client is unlocked when coupled with a Pro account,
  # Admin will administer an organizational unit, SuperUser is for internal use

  ROLES = %w[user client pro admin superuser banned]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    rails_user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if rails_user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email # if email_is_verified
      rails_user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if rails_user.nil?
        rail_user = User.new(
          #name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        rails_user.skip_confirmation!
        rails_user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.rails_user != rails_user
      identity.rails_user = rails_user
      identity.save!
    end
    rails_user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
  roles.include?(role.to_s)
  end
end