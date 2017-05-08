require "date"

require "omise/schedule"

module Omise
  class Scheduler
    WEEKDAYS       = Date::DAYNAMES.map(&:downcase).freeze
    MONTH_WEEKDAYS = %w[first second third fourth last]
      .product(WEEKDAYS)
      .map { |d| d.join("_") }
      .freeze

    def initialize(type, attributes = {}, options = {})
      @type       = type
      @attributes = attributes
      @every      = options[:every]
      @period     = options[:period]
      @on         = options[:on]
      @end_date   = options[:end_date]
    end

    def type
      @type.to_s
    end

    def every(n = 1)
      unless n.is_a?(Integer)
        raise TypeError, "#{n} is not an Integer"
      end

      renew(every: n)
    end

    def days
      renew(period: "day", on: nil)
    end
    alias_method :day, :days

    def weeks(on:)
      on.each do |day|
        unless WEEKDAYS.include?(day)
          raise "#{day} is not one of #{WEEKDAYS}"
        end
      end

      renew(period: "week", on: { weekdays: on })
    end
    alias_method :week, :weeks

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

    def end_date(date)
      date = Date.parse(date.to_s)
      renew(end_date: date.iso8601)
    end

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

    def start
      Schedule.create(to_attributes)
    end

    def to_attributes
      {}.tap do |a|
        a[@type]     = @attributes
        a[:every]    = @every if @every
        a[:period]   = @period if @period
        a[:on]       = @on if @on
        a[:end_date] = @end_date if @end_date
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
        raise "#{day} does not match #{WEEKDAY_OF_MONTH.inspect}"
      end

      renew(period: "month", on: { weekday_of_month: day })
    end

    def renew(attributes)
      self.class.new(@type, @attributes, {
        every:    @every,
        period:   @period,
        on:       @on,
        end_date: @end_date,
      }.merge(attributes))
    end
  end
end
