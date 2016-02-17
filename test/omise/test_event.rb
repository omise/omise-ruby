require "support"

class TestEvent < Omise::Test
  setup do
    @event = Omise::Event.retrieve("evnt_test_52cin5n9bb6lytxduh9")
  end

  def test_that_we_can_list_all_events
    events = Omise::Event.list

    assert_instance_of Omise::List, events
  end

  def test_that_we_can_retrieve_a_event
    assert_instance_of Omise::Event, @event
    assert_equal "evnt_test_52cin5n9bb6lytxduh9", @event.id
  end
end
