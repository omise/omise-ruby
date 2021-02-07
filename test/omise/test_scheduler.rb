require "support"

class TestScheduler < Omise::Test
  setup do
    @scheduler = Omise::Charge.schedule
  end

  def test_that_a_scheduler_has_a_type
    assert_equal "charge", @scheduler.type
  end

  def test_we_can_set_every
    scheduler = @scheduler.every(1)

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 1, scheduler.to_attributes[:every]
  end

  def test_we_can_set_day
    scheduler = @scheduler.every(1).day

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 1, scheduler.to_attributes[:every]
    assert_equal "day", scheduler.to_attributes[:period]
    assert_nil scheduler.to_attributes[:on]
  end

  def test_we_can_set_days
    scheduler = @scheduler.every(10).days

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 10, scheduler.to_attributes[:every]
    assert_equal "day", scheduler.to_attributes[:period]
    assert_nil scheduler.to_attributes[:on]
  end

  def test_we_can_set_week
    scheduler = @scheduler.every(1).week(on: ["monday"])

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 1, scheduler.to_attributes[:every]
    assert_equal "week", scheduler.to_attributes[:period]
    assert_equal ["monday"], scheduler.to_attributes[:on][:weekdays]
  end

  def test_we_can_set_weeks
    scheduler = @scheduler.every(2).weeks(on: ["monday"])

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 2, scheduler.to_attributes[:every]
    assert_equal "week", scheduler.to_attributes[:period]
    assert_equal ["monday"], scheduler.to_attributes[:on][:weekdays]
  end

  def test_we_can_set_month_with_days
    scheduler = @scheduler.every(1).month(on: [1, 10, 20])

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 1, scheduler.to_attributes[:every]
    assert_equal "month", scheduler.to_attributes[:period]
    assert_equal [1, 10, 20], scheduler.to_attributes[:on][:days_of_month]
  end

  def test_we_can_set_months_with_days
    scheduler = @scheduler.every(3).months(on: [1])

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 3, scheduler.to_attributes[:every]
    assert_equal "month", scheduler.to_attributes[:period]
    assert_equal [1], scheduler.to_attributes[:on][:days_of_month]
  end

  def test_we_can_set_month_with_weekday
    scheduler = @scheduler.every(1).month(on: "first_monday")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 1, scheduler.to_attributes[:every]
    assert_equal "month", scheduler.to_attributes[:period]
    assert_equal "first_monday", scheduler.to_attributes[:on][:weekday_of_month]
  end

  def test_we_can_set_month_with_weekday_in_other_formats
    scheduler = @scheduler.every(1).month(on: "1st_monday")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 1, scheduler.to_attributes[:every]
    assert_equal "month", scheduler.to_attributes[:period]
    assert_equal "1st_monday", scheduler.to_attributes[:on][:weekday_of_month]
  end

  def test_we_can_set_months_with_weekday
    scheduler = @scheduler.every(3).months(on: "last_friday")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal 3, scheduler.to_attributes[:every]
    assert_equal "month", scheduler.to_attributes[:period]
    assert_equal "last_friday", scheduler.to_attributes[:on][:weekday_of_month]
  end

  def test_we_can_set_end_date
    scheduler = @scheduler.end_date("2018-01-01")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal "2018-01-01", scheduler.to_attributes[:end_date]
  end

  def test_we_can_set_end_date_in_other_formats
    scheduler = @scheduler.end_date("1st January 2018")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal "2018-01-01", scheduler.to_attributes[:end_date]
  end

  def test_we_can_set_start_date
    scheduler = @scheduler.start_date("2018-01-01")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal "2018-01-01", scheduler.to_attributes[:start_date]
  end

  def test_we_can_set_start_date_in_other_formats
    scheduler = @scheduler.start_date("1st January 2018")

    assert_scheduler_attributes(@scheduler)
    refute_equal scheduler.object_id, @scheduler.object_id
    assert_equal "2018-01-01", scheduler.to_attributes[:start_date]
  end

  def that_we_can_parse_it_all_in_one
    scheduler = @scheduler.parse("every 1 month on the 28th until May 1st, 2018")

    assert_scheduler_attributes(@scheduler)
    assert_scheduler_attributes(scheduler, 1, "month", "2018-05-01", days_of_month: [28])
  end

  def test_a_bunch_of_other_values_to_be_parsed
    scheduler = @scheduler.parse("every day until 03/04/2018")
    assert_scheduler_attributes(scheduler, 1, "day", "2018-04-03")

    scheduler = @scheduler.parse("every 10 days until 03/04/2018")
    assert_scheduler_attributes(scheduler, 10, "day", "2018-04-03")

    scheduler = @scheduler.parse("every 2 weeks on monday and friday until 2018-12-12")
    assert_scheduler_attributes(scheduler, 2, "week", "2018-12-12", weekdays: ["monday", "friday"])

    scheduler = @scheduler.parse("every 1 week on monday, tuesday, wednesday, thursday, friday until 2018-12-12")
    assert_scheduler_attributes(scheduler, 1, "week", "2018-12-12", weekdays: ["monday", "tuesday", "wednesday", "thursday", "friday"])

    scheduler = @scheduler.parse("every 2 weeks on monday and monday until 2018-12-12")
    assert_scheduler_attributes(scheduler, 2, "week", "2018-12-12", weekdays: ["monday"])

    scheduler = @scheduler.parse("every month on the third Thursday until January 1st 2020")
    assert_scheduler_attributes(scheduler, 1, "month", "2020-01-01", weekday_of_month: "third_thursday")

    scheduler = @scheduler.parse("every month on the 2nd Monday until January 1st 2020")
    assert_scheduler_attributes(scheduler, 1, "month", "2020-01-01", weekday_of_month: "2nd_monday")

    scheduler = @scheduler.parse("every 3 months on 1, 2 and 3 until January 1st 2020")
    assert_scheduler_attributes(scheduler, 3, "month", "2020-01-01", days_of_month: [1, 2, 3])
  end

  def test_that_we_can_start_the_schedule
    schedule = @scheduler.parse("every 1 month on the 28th until May 1st, 2018").start

    assert_instance_of Omise::Schedule, schedule
  end

  private

  def assert_scheduler_attributes(scheduler, every = nil, period = nil, end_date = nil, on = nil)
    if every
      assert_equal every, scheduler.to_attributes[:every]
    else
      assert_nil every
    end

    if period
      assert_equal period, scheduler.to_attributes[:period]
    else
      assert_nil period
    end

    if end_date
      assert_equal end_date, scheduler.to_attributes[:end_date]
    else
      assert_nil end_date
    end

    if on
      assert_equal on, scheduler.to_attributes[:on]
    else
      assert_nil on
    end
  end
end
