require 'test_helper'

class UserFeedAbilityTest < ActiveSupport::TestCase
  def setup
    @service = feeds(:service)
    @secret = feeds(:secret_announcements)
  end

  test "Anyone can read viewable feed" do
    ability = Ability.new(User.new)
    assert ability.can?(:read, @service)
  end

  test "Anyone cannot read nonviewable feed" do
    ability = Ability.new(User.new)
    assert ability.cannot?(:read, @secret)
  end

  test "Group member can read nonviewable feed" do
    ability = Ability.new(users(:katie))
    assert ability.can?(:read, @secret)
  end

  test "Non Group member cannot read nonviewable feed" do
    ability = Ability.new(users(:kristen))
    assert ability.cannot?(:read, @secret)
  end

  test "Only group leaders can delete / update feed" do
    ability = Ability.new(users(:katie))
    assert ability.can?(:update, @service)
    assert ability.can?(:delete, @service)

    ability = Ability.new(users(:kristen))
    assert ability.cannot?(:update, @service)
    assert ability.cannot?(:delete, @service)

    ability = Ability.new(User.new)
    assert ability.cannot?(:update, @service)
    assert ability.cannot?(:delete, @service)
  end
end

