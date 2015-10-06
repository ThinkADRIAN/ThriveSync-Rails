class User < ActiveRecord::Base
  acts_as_messageable

  has_many :moods
  has_many :sleeps
  has_many :self_cares
  has_many :journals

  has_friendship

  has_many :reminders

  has_one :scorecard, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_one :review, dependent: :destroy

  has_many :relationships
  has_many :relations, :through => :relationships
  
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "relation_id"
  has_many :inverse_relations, :through => :inverse_relationships, :source => :user

  has_many :invitations, :class_name => self.to_s, :as => :invited_by

  before_create :set_default_role
  after_create :create_scorecard
  after_create :create_reward
  after_create :create_reminders
  after_create :create_review

  after_create :identify_user_for_analytics
  after_create :track_user_sign_up

  # User is free account, Client is unlocked when coupled with a Pro account,
  # Admin will administer an organizational unit, SuperUser is for internal use

  ROLES = %w[user client pro admin superuser supporter]

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
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

  def create_reminders
    @reminder = Reminder.new
    @reminder.user_id = self.id
    @reminder.message = "Good Morning.  How did you sleep last night?"
    @reminder.sunday_enabled = false
    @reminder.monday_enabled = true
    @reminder.tuesday_enabled = true
    @reminder.wednesday_enabled = true
    @reminder.thursday_enabled = true
    @reminder.friday_enabled = true
    @reminder.saturday_enabled = false
    @reminder.alert_time = "8:00:00"
    @reminder.save

    @reminder = Reminder.new
    @reminder.user_id = self.id
    @reminder.message = "Good Afternoon.  How is your day going?"
    @reminder.sunday_enabled = true
    @reminder.monday_enabled = false
    @reminder.tuesday_enabled = false
    @reminder.wednesday_enabled = false
    @reminder.thursday_enabled = false
    @reminder.friday_enabled = false
    @reminder.saturday_enabled = true
    @reminder.alert_time = "12:00:00"
    @reminder.save


    @reminder = Reminder.new
    @reminder.user_id = self.id
    @reminder.message = "Good Evening? How was your mood today?"
    @reminder.sunday_enabled = true
    @reminder.monday_enabled = true
    @reminder.tuesday_enabled = true
    @reminder.wednesday_enabled = true
    @reminder.thursday_enabled = true
    @reminder.friday_enabled = true
    @reminder.saturday_enabled = true
    @reminder.alert_time = "18:00:00"
    @reminder.save
  end

  def create_review
    @review = Review.new
    @review.user_id = self.id
    @review.save
  end

  #Returning any kind of identification you want for the model
  def name
    return self[:first_name]
  end

  #Returning the email address of the model if an email should be sent for this object (Message or Notification).
  #If no mail has to be sent, return nil.
  def mailboxer_email(object)
    #Check if an email should be sent for that object
    #if true
    return self[:email]
    #if false
    #return nil
  end

  def identify_user_for_analytics
    # Identify User for Segment.io Analytics
    Analytics.identify(
      user_id: self.id,
      traits: {
        created_at: self.created_at
      }
    )
  end

  def track_user_sign_up
    # Track User Sign Up for Segment.io Analytics
    Analytics.track(
      user_id: self.id,
      event: 'Signed Up',
      properties: {
      }
    )
  end
end