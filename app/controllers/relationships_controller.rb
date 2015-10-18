class RelationshipsController < ApplicationController
	def create
	  @relationship = current_user.relationships.build(:relation_id => params[:relation_id])
	  if @relationship.save
	    flash[:notice] = 'Added relationship.'
	    redirect_to root_url
	  else
	    flash[:notice] = 'Unable to add relation.'
	    redirect_to root_url
	  end
	end

	def destroy
	  @relationship = current_user.relationships.find(params[:id])
	  @relationship.destroy
	  flash[:notice] = 'Removed relationship.'
	  redirect_to current_user
	end

	def self.request(user, relation)
    unless user == relation or Relationship.exists?(user, relation)
      transaction do
        create(user: user, relation: relation, status: 'pending')
        create(user: relation, relation: rail_user, status: 'requested')
      end
    end
  end

  def self.accept(user, relation)
    transaction do
      accepted_at = Time.now
      accept_one_side(user, relation, accepted_at)
      accept_one_side(relation, user, accepted_at)
    end
  end

  def self.accept_one_side(user, relation, accepted_at)
    request = find_by_user_id_and_relation_id(user, relation)
    request.status = 'accepted'
    request.accepted_at = accepted_at
    request.save!
  end
end
