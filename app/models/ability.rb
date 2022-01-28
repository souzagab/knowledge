# User abilities (Authorization)
class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all if user.admin?

    # Normal users can only see the enrolled courses
    can :read, Course, attendees: { id: user.id }
    # can only see content of the enrolled courses
    can :read, Content, course: { attendees: { id: user.id } }
  end
end
