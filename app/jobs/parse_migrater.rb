class ParseMigrater
  @queue = :migration

  def self.perform(user_id, email, password)
    etl_for_parse(user_id, email, password)
  end
end