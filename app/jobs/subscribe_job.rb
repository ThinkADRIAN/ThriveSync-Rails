class SubscribeJob
  include SuckerPunch::Job

  def perform(user)
    gibbon = Gibbon::Request.new

    ActiveRecord::Base.connection_pool.with_connection do
      gibbon.lists(ENV["MAILCHIMP_LIST_ID"]).members.create(body: {email_address: user.email, status: "subscribed", merge_fields: {FNAME: user.first_name, LNAME: user.last_name}})
    end
  end
end