require "omise/search"

module Omise
  class SearchScope
    def initialize(scope, available_filters = [], options = {})
      @scope             = scope.to_s
      @available_filters = available_filters
      @filters           = options.delete(:filters) { Hash.new }
      @order             = options.delete(:order)
      @page              = options.delete(:page)
      @query             = options.delete(:query)
    end

    attr_reader :scope, :available_filters

    def filter(filters = {})
      filters.each do |key, value|
        break if @available_filters.empty?
        if !@available_filters.include?(key.to_s)
          raise "#{key} is not a recognized filter for #{@scope}"
        end
      end

      renew(filters: @filters.merge(filters))
    end

    def query(terms = nil)
      return self if !terms
      renew(query: terms)
    end

    def order(order)
      renew(order: order)
    end

    def page(number)
      renew(page: number)
    end

    def execute
      Search.execute(to_attributes)
    end

    def to_attributes
      attributes = {}

      attributes[:scope]   = @scope
      attributes[:filters] = @filters if @filters.any?
      attributes[:query]   = @query if @query
      attributes[:order]   = @order if @order
      attributes[:page]    = @page if @page

      attributes
    end

    private

    def renew(attributes)
      self.class.new(@scope, @available_filters, {
        query:   @query,
        filters: @filters,
        order:   @order,
        page:    @page,
      }.merge(attributes))
    end
  end
end
