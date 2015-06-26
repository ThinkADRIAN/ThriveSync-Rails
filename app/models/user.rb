class User < ActiveRecord::Base
  include Amistad::FriendModel

  searchable do
    string :email
  end

	has_many :moods
  has_many :sleeps
  has_many :self_cares
  has_many :journals

  has_one :scorecard, dependent: :destroy
  has_one :reward, dependent: :destroy

  has_many :relationships
  has_many :relations, :through => :relationships
  
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "relation_id"
  has_many :inverse_relations, :through => :inverse_relationships, :source => :user

  before_create :set_default_role
  after_create :create_scorecard
  after_create :create_reward

  # User is free account, Client is unlocked when coupled with a Pro account,
  # Admin will administer an organizational unit, SuperUser is for internal use

  ROLES = %w[user client pro admin superuser banned]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable 

  validates_presence_of :first_name, :last_name

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  accepts_nested_attributes_for :reward

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email # if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          #name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          first_name: auth.extra.raw_info.first_name,
          last_name: auth.extra.raw_info.last_name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
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

  def role_symbols
    roles.map(&:to_sym)
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def set_default_role
    self.roles = [ "user" ]
  end

  def authorize
    unless current_user.is? :pro
    end
  end

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  def create_scorecard
    @scorecard = Scorecard.new
    @scorecard.user_id = self.id
    @scorecard.save
  end

  def create_reward
    @reward = Reward.new
    @reward.user_id = self.id
    @reward.save
  end
end