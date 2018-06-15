require "support"

class TestSchedule < Omise::Test
  setup do
    @schedule = Omise::Schedule.retrieve("schd_test_4yq7duw15p9hdrjp8oq")
  end

  def test_that_we_can_list_all_schedules
    schedules = Omise::Schedule.list

    assert_instance_of Omise::List, schedules
    assert_instance_of Omise::Schedule, schedules.first
  end

  def test_that_we_can_retrieve_a_schedule
    assert_instance_of Omise::Schedule, @schedule
  end

  def test_that_we_can_create_a_schedule
    schedule = Omise::Schedule.create({
      every:      1,
      period:     "month",
      start_date: "2017-05-01",
      end_date:   "2018-05-01",
      on: {
        days_of_month: [1],
      },
      charge: {
        customer:    "cust_test_57m2wcnfx96k634rkqq",
        amount:      "100000",
      },
    })

    assert_instance_of Omise::Schedule, schedule
  end

  def test_that_we_can_destroy_a_schedule
    @schedule.destroy

    assert @schedule.destroyed?
  end

  def test_that_we_can_get_correct_schedule_status_when_it_destroyed
    refute @schedule.destroyed?

    @schedule.destroy

    assert @schedule.destroyed?
  end

  def test_that_we_can_list_occurences
    occurrences = @schedule.occurrences

    assert_instance_of Omise::OccurrenceList, occurrences
    assert_instance_of Omise::Occurrence, occurrences.first
  end
end
