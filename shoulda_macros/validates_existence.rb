# Based on http://github.com/shuber/validates_existence
class Test::Unit::TestCase
  def self.should_validate_existence_of(*associations)
    allow_nil = get_options!(associations, :allow_nil)

    associations.each do |association|
      should "require #{association} exists" do
        reflection = subject.class.reflect_on_association(association)
        object = subject
        object.send("#{reflection.primary_key_name}=", 0)
        assert !object.valid?, "#{subject.class} was saved with a non-existent #{association}"
        assert object.errors.on(association), "There are no errors on #{association} after being set to a non-existent record"
        assert_contains(object.errors.on(association), "does not exist", "when set to 0")
      end
    end

    if allow_nil
      associations.each do |association|
        should "allow #{association} to be nil" do
          reflection = subject.class.reflect_on_association(association)
          object = subject
          object.send("#{reflection.primary_key_name}=", nil)
          object.valid?
          assert !object.errors.on(association), "There were errors on #{association} after being set to nil"
        end
      end
    end
  end
end
