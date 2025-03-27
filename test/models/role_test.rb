require "test_helper"

class RoleTest < ActiveSupport::TestCase
  def setup
    @role = Role.new(name: "Admin")
  end

  test "should be valid" do
    assert @role.valid?
  end

  test "should require a name" do
    @role.name = nil
    assert_not @role.valid?
  end
end
