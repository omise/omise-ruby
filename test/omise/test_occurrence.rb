require "support"

class TestOccurrence < Omise::Test
  setup do
    @schedule = Omise::Schedule.retrieve("schd_test_4yq7duw15p9hdrjp8oq")
    @occurrence = Omise::Occurrence.retrieve("occu_test_57s33hmja9t3fs4wmop")
  end

  def test_that_we_can_retrieve_an_occurrence
    occurrence = Omise::Occurrence.retrieve("occu_test_57s33hmja9t3fs4wmop")

    assert_instance_of Omise::Occurrence, occurrence
  end

  def test_that_we_can_reload_an_occurrence
    occurrence = Omise::Occurrence.retrieve("occu_test_57s33hmja9t3fs4wmop")

    occurrence.reload

    assert_instance_of Omise::Occurrence, occurrence
  end

  def test_that_we_can_expand_a_schedule
    occurrence = Omise::Occurrence.retrieve("occu_test_57s33hmja9t3fs4wmop")
    schedule = occurrence.schedule

    assert_instance_of Omise::Schedule, schedule
  end
end
