class ParseMigrater
  extend ParseHelper
  include SuckerPunch::Job

  def perform(user_id, email, password)
    ParseMigrater.etl_for_parse(user_id, email, password, false)
  end

  def perform_admin(user_id, email)
    ParseMigrater.etl_for_parse_admin(user_id, email, false)
  end

  def perform_update_scores(user_id, email, password)
    ParseMigrater.etl_for_parse(user_id, email, password, true)
  end
end