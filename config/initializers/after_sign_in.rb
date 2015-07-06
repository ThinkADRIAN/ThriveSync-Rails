Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  Analytics.track(
    user_id: user.id,
    event: 'Logged In',
    properties: {
    }
  )
end