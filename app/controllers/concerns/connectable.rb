module Connectable
  extend ActiveSupport::Concern

  included do
    before_create :generate_connect_token
  end

  protected

  def generate_connect_token
    self.connect_uuid = loop do
      random_token = SecureRandom.urlsafe_base64(8, false)
      break random_token unless self.class.exists?(connect_uuid: random_token)
    end
  end
end