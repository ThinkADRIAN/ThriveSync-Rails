=begin
require 'flipper'
require 'flipper/adapters/activerecord'

# Group Registration
Flipper.register(:research_participants) do |actor|
  !actor.research_started_at.nil? && DateTime.now > actor.research_started_at + 30.days
end

# Configure Adapter & Initialize Flipper DSL
adapter = Flipper::Adapters::ActiveRecord.new
$flipper = Flipper.new(adapter)

# Grab features
peer_support = $flipper[:peer_support]
provider_support = $flipper[:provider_support]

# Configure Feature Access
peer_support.enable($flipper.group(:research_participants))
provider_support.enable($flipper.group(:research_participants))
=end