require "support"

class TestLink < Omise::Test
  setup do
    @link = Omise::Link.retrieve("link_test_55pcclmznvrv9lc7r9s")
  end

  def test_that_we_can_create_a_link
    link = Omise::Link.create

    assert_instance_of Omise::Link, link
    assert_equal "link_test_55pcclmznvrv9lc7r9s", link.id
  end

  def test_that_we_can_retrieve_a_link
    assert_instance_of Omise::Link, @link
    assert_equal "link_test_55pcclmznvrv9lc7r9s", @link.id
  end

  def test_that_we_can_destroy_a_link
    @link.destroy

    assert @link.deleted
    assert @link.destroyed?
  end

  def test_that_we_can_list_all_links
    links = Omise::Link.list

    assert_instance_of Omise::List, links
  end

  def test_that_we_can_reload_a_link
    @link.attributes.taint
    @link.reload

    refute @link.attributes.tainted?
  end

  def test_that_a_link_has_a_list_of_charges
    assert_instance_of Omise::ChargeList, @link.charges
  end
end
