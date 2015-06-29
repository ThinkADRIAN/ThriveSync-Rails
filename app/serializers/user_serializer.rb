class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :last_sign_in_at, :last_seen_at, :roles_mask, :first_name, :last_name, :clients, :authentication_token
end