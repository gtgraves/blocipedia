class CollaboratorPolicy < ApplicationPolicy
  attr_reader :user, :collaborator

  def initialize(user, collaborator)
    @user = user
    @collaborator = collaborator
  end

  def new?
    requirements
  end

  def create?
    requirements
  end

  def destroy?
    requirements
  end

  private

  def requirements
    wiki = collaborator.wiki
    (user.admin? or user.premium?) and wiki.user == user
  end
end
