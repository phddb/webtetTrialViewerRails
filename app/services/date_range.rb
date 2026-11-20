class DateRange
  class Invalid < StandardError; end

  attr_reader :start_at, :end_at

  def self.from_params(start_date:, end_date:)
    start_value = blank_to_nil(start_date)
    end_value = blank_to_nil(end_date)

    start_at = parse_start(start_value)
    end_at = parse_end(end_value)

    if start_at && end_at && start_at > end_at
      raise Invalid, "start must be before or equal to end"
    end

    new(start_at:, end_at:)
  end

  def initialize(start_at:, end_at:)
    @start_at = start_at
    @end_at = end_at
  end

  def blank?
    start_at.nil? && end_at.nil?
  end

  def warehouse_query
    query = {}
    query[:start] = start_at.iso8601(3) if start_at
    query[:end] = end_at.iso8601(3) if end_at
    query
  end

  def self.blank_to_nil(value)
    value = value.to_s.strip
    value.empty? ? nil : value
  end
  private_class_method :blank_to_nil

  def self.parse_start(value)
    return nil unless value

    date = Date.iso8601(value)
    Time.utc(date.year, date.month, date.day)
  rescue ArgumentError
    raise Invalid, "start must be a valid date"
  end
  private_class_method :parse_start

  def self.parse_end(value)
    return nil unless value

    date = Date.iso8601(value)
    Time.utc(date.year, date.month, date.day, 23, 59, 59, Rational("999999"))
  rescue ArgumentError
    raise Invalid, "end must be a valid date"
  end
  private_class_method :parse_end
end
