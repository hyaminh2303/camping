class RoleConstraint
  attr_accessor :role

  def initialize(role)
    @role = role
  end

  def matches?(request)
    return true if request.env['warden'].user.blank?

    request.env['warden'].user.send("is_#{role.to_s}?")

  end

end