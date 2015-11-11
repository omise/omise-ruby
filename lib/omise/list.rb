require "omise/util"
require "omise/object"

module Omise
  class List < OmiseObject
    include Enumerable

    def initialize(attributes = {}, options = {})
      super(attributes, options)
    end

    def reload(attributes = {})
      @data = nil
      assign_attributes resource(attributes).get(attributes)
    end

    def parent
      @options[:parent]
    end

    def data
      @data ||= @attributes["data"].map { |o| Omise::Util.typecast(o) }
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
      self.class.new(@attributes, @options).next_page!
    end

    def previous_page
      self.class.new(@attributes, @options).previous_page!
    end

    def jump_to_page(page)
      self.class.new(@attributes, @options).jump_to_page!(page)
    end

    def next_page!
      jump_to_page!(page + 1)
    end

    def previous_page!
      jump_to_page!(page - 1)
    end

    def jump_to_page!(page)
      return nil if page < 1
      new_offset = ((page - 1) * limit)
      return nil if new_offset >= total
      reload(offset: new_offset, limit: limit)
      self
    end

    def each(*args, &block)
      to_a.each(*args, &block)
    end

    def to_a
      data
    end

    def last
      to_a.last
    end
  end
end
