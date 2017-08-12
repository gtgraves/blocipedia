class ChargePolicy < Struct.new(:user, :charge)
  attr_reader :user, :charge

  def initialize(user, charge)
    @user = user
  end

  def new?
    user.standard?
  end

  def create?
    user.standard?
  end
end
