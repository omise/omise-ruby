require "omise/util"
require "omise/object"

module Omise
  class List < OmiseObject
    include Enumerable

    def initialize(attributes = {}, options = {})
      super(attributes, options)
      setup_data
    end

    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes) do
        setup_data
      end
    end

    def parent
      @options[:parent]
    end

    def first_page?
      offset == 0
    end

    def last_page?
      offset + limit >= total
    end

    def page
      1 + (offset / limit)
    end

    def total_pages
      (total.to_f / limit).ceil
    end

    def next_page
      self.class.new(@attributes, @options).send(:next_page!)
    end

    def previous_page
      self.class.new(@attributes, @options).send(:previous_page!)
    end

    def jump_to_page(page)
      self.class.new(@attributes, @options).send(:jump_to_page!, page)
    end

    def each(*args, &block)
      to_a.each(*args, &block)
    end

    def to_a
      @data
    end

    def last
      to_a.last
    end

    private

    def jump_to_page!(page)
      new_offset = ((page - 1) * limit)
      return nil if new_offset >= total
      reload(offset: new_offset, limit: limit)
      self
    end

    def next_page!
      return nil if (offset + limit) >= total
      reload(offset: offset + limit, limit: limit)
      self
    end

    def previous_page!
      return nil if (offset - limit) < 0
      reload(offset: offset - limit, limit: limit)
      self
    end

    def setup_data
      @data = @attributes["data"].map { |o| Omise::Util.typecast(o) }
    end
  end
end
