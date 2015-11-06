class ParseMigrater
  extend ParseHelper
  include SuckerPunch::Job

  def perform(user_id, email, password)
    ParseMigrater.etl_for_parse(user_id, email, password)
  end
end