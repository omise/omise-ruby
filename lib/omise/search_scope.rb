require "omise/search"

module Omise
  class SearchScope
    def initialize(scope, options = {})
      @scope             = scope.to_s
      @filters           = options.delete(:filters) { Hash.new }
      @order             = options.delete(:order)
      @page              = options.delete(:page)
      @query             = options.delete(:query)
    end

    attr_reader :scope

    def filter(filters = {})
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
      attributes = {}

      attributes[:scope]   = @scope
      attributes[:filters] = @filters if @filters.any?
      attributes[:query]   = @query if @query
      attributes[:order]   = @order if @order
      attributes[:page]    = @page if @page

      Search.execute(attributes)
    end

    private

    def renew(attributes)
      self.class.new(@scope, {
        query:   @query,
        filters: @filters,
        order:   @order,
        page:    @page,
      }.merge(attributes))
    end
  end
end
