class ParseMigrater
  extend ParseHelper

  @queue = :migration

  def self.perform(user_id, email, password)
    ParseMigrater.etl_for_parse(user_id, email, password)
  end
end