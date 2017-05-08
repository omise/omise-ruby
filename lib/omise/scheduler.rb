require "date"

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

    def every(n = 1)
      unless n.is_a?(Integer)
        raise TypeError, "#{n} is not an Integer"
      end

      renew(every: n)
    end

    def parse(str)
      str = str.downcase
        .gsub(/ +/, " ")
        .gsub("every ", "")
        .gsub("the ", "")
        .gsub(" and ", ",")
        .gsub(/ ?, ?/, ",")
        .gsub(/,+/, ",")

      leftover, end_date = str.split(" until ", 2)
      period, on         = leftover.split(" on ", 2)

      schedule = self.end_date(end_date)

      if period.include?("day")
        every = period.to_i
        every = 1 if every.zero?

        return schedule.every(every).days
      end

      if period.include?("week")
        every    = period.to_i
        every    = 1 if every.zero?
        weekdays = on.strip.split(",")

        return schedule.every(every).weeks(on: weekdays)
      end

      if period.include?("month")
        every         = period.to_i
        every         = 1 if every.zero?
        month_weekday = on.strip.split(" ").join("_")
        month_days    = on.strip.split(",").map { |d| d.to_i }

        if MONTH_WEEKDAYS.include?(month_weekday)
          return schedule.every(every).months(on: month_weekday)
        else
          return schedule.every(every).months(on: month_days)
        end
      end

      raise "parser failed"
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
      unless date.is_a?(Date)
        begin
          date = Date.parse(date.to_s)
        rescue
          raise TypeError, "#{date} can't be parsed into a date"
        end
      end

      renew(end_date: date.iso8601)
    end

    def start
      attributes = {}

      attributes[@type]     = @attributes
      attributes[:every]    = @every if @every
      attributes[:period]   = @period if @period
      attributes[:on]       = @on if @on
      attributes[:end_date] = @end_date if @end_date

      Schedule.create(attributes)
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
