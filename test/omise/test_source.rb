require "support"

class TestSource < Omise::Test
  setup do
    @id = "src_test_59trf2nxk43b5nml8z0"
    @source = Omise::Source.retrieve @id
  end

  def test_that_we_can_create_a_source
    source = Omise::Source.create

    assert_instance_of Omise::Source, source
    assert_equal @id, source.id
  end

  def test_that_we_can_retrieve_a_source
    assert_instance_of Omise::Source, @source
    assert_equal @id, @source.id
  end
end
