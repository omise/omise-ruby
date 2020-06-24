module Omise
  class Scheduler
    WEEKDAYS = %w[sunday monday tuesday wednesday thursday friday saturday]
    MONTH_WEEKDAYS = %w[first_sunday first_monday first_tuesday first_wednesday
      first_thursday first_friday first_saturday second_sunday second_monday
      second_tuesday second_wednesday second_thursday second_friday
      second_saturday third_sunday third_monday third_tuesday third_wednesday
      third_thursday third_friday third_saturday fourth_sunday fourth_monday
      fourth_tuesday fourth_wednesday fourth_thursday fourth_friday
      fourth_saturday last_sunday last_monday last_tuesday last_wednesday
      last_thursday last_friday last_saturday
    ]

    def initialize(type, attributes = {}, options = {})
      @type       = type
      @attributes = attributes
      @every      = options[:every]
      @period     = options[:period]
      @on         = options[:on]
      @end_date   = options[:end_date]
      @start_date = options[:start_date]
    end

    # The type of schedule you're trying to create. This can either be charge
    # or transfer.
    #
    # Returns a string.
    #
    def type
      @type.to_s
    end

    # Sets the interval between each occurence. The value must be an integer.
    # For example:
    #
    #     scheduler.every(1).days
    #
    # Returns self.
    #
    def every(n = 1)
      unless n.is_a?(Integer)
        raise TypeError, "#{n} is not an Integer"
      end

      renew(every: n)
    end

    # Sets the period type to `day`. For example:
    #
    #     scheduler.every(2).days
    #
    # This method is also aliased with the singular form.
    #
    # Returns self.
    #
    def days
      renew(period: "day", on: nil)
    end
    alias_method :day, :days

    # Sets the period type to `week`. And you must pass on which days of the
    # week the schedule will be run. For example:
    #
    #     scheduler.every(2).weeks(on: ["monday"])
    #
    # This method is also aliased with the singular form.
    #
    # Returns self.
    #
    def weeks(on:)
      on.each do |day|
        unless WEEKDAYS.include?(day)
          raise "#{day} is not one of #{WEEKDAYS}"
        end
      end

      renew(period: "week", on: { weekdays: on })
    end
    alias_method :week, :weeks

    # Sets the period type to `month`. And you must pass on which day(s) of the
    # month the schedule will be run. Either as an array of integers if you
    # want specific dates during the month. For example:
    #
    #     scheduler.every(1).month(on: [1, 15])
    #
    # Or as keyword specifying on which weekday the schedule should be executed.
    # For example:
    #
    #     scheduler.every(1).month(on: "last_friday")
    #
    # All the available keywords can be found in {MONTH_WEEKDAYS}.
    #
    # This method is also aliased with the singular form.
    #
    # Returns self.
    #
    def months(on:)
      case on
      when Array
        month_with_days(on)
      when String
        month_with_weekday(on)
      else
        raise TypeError, "#{on.inspect} must be an Array or a String, not a #{on.class}"
      end
    end
    alias_method :month, :months

    # Sets the date at which the schedule must start. Note that if the start
    # date is equal to the current date, the first occurence of the schedule
    # will be executed right away.
    #
    # Returns self.
    #
    def start_date(date)
      date = Date.parse(date.to_s)
      renew(start_date: date.iso8601)
    end

    # Sets the date after which there must not be any new occurences.
    #
    # Returns self.
    #
    def end_date(date)
      date = Date.parse(date.to_s)
      renew(end_date: date.iso8601)
    end

    # Parses a complex sentence representing a schedule. Here's some example
    # sentences that can be parsed:
    #
    #   - every day until 03/04/2018
    #   - every 10 days until 03/04/2018")
    #   - every 2 weeks on monday and friday until 2018-12-12
    #   - every 1 week on monday, tuesday, thursday and friday until 2018-12-12
    #   - every 2 weeks on monday and monday until 2018-12-12
    #   - every month on the third Thursday until January 1st 2020
    #   - every 3 months on 1, 2 and 3 until January 1st 2020
    #
    # Returns self.
    #
    def parse(str)
      str = str.downcase
        .gsub(/ +/, " ")
        .gsub("every ", "")
        .gsub("the ", "")
        .gsub(" and ", ",")
        .gsub(/,+/, ",")
        .gsub(/ ?, ?/, ",")
        .gsub(",", " ")

      leftover, end_date = str.split(" until ", 2)
      period, on         = leftover.split(" on ", 2)
      on                 = on.to_s.strip.split(" ")
      every              = period.to_i
      every              = 1 if every.zero?
      month_weekday      = on.join("_")
      month_days         = on.map { |d| d.to_i }

      schedule = self.end_date(end_date).every(every)

      if period.include?("day")
        return schedule.days
      end

      if period.include?("week")
        return schedule.weeks(on: on.uniq)
      end

      if period.include?("month") && MONTH_WEEKDAYS.include?(month_weekday)
        return schedule.months(on: month_weekday)
      end

      if period.include?("month")
        return schedule.months(on: month_days.uniq)
      end

      raise ArgumentError, "invalid schedule: #{src}"
    end

    # Creates the schedule by passing the hash from {to_attributes}. See 
    # {Schedule.create} for more informations about creating schedules.
    #
    # Returns a {Schedule}.
    #
    def start
      Schedule.create(to_attributes)
    end

    # Dumps the generated attributes.
    #
    # Returns a Hash.
    #
    def to_attributes
      {}.tap do |a|
        a[@type]       = @attributes
        a[:every]      = @every if @every
        a[:period]     = @period if @period
        a[:on]         = @on if @on
        a[:end_date]   = @end_date if @end_date
        a[:start_date] = @start_date if @start_date
      end
    end

    private

    def month_with_days(days)
      days.each do |day|
        unless day.is_a?(Integer)
          raise TypeError, "#{day.inspect} must be an Integer, not a #{day.class}"
        end
      end

      renew(period: "month", on: { days_of_month: days })
    end

    def month_with_weekday(day)
      unless MONTH_WEEKDAYS.include?(day)
        raise "#{day} does not match #{MONTH_WEEKDAYS.inspect}"
      end

      renew(period: "month", on: { weekday_of_month: day })
    end

    def renew(attributes)
      self.class.new(@type, @attributes, {
        every:      @every,
        period:     @period,
        on:         @on,
        end_date:   @end_date,
        start_date: @start_date,
      }.merge(attributes))
    end
  end
end
