require "support"

class TestSearchScope < Omise::Test
  setup do
    @scope = Omise::SearchScope.new(:charge, %w[created status])
  end

  def test_that_we_can_initialize_a_new_search_scope
    assert_instance_of Omise::SearchScope, @scope
    assert_equal "charge", @scope.scope
    assert_instance_of Array, @scope.available_filters
    assert_equal %w[created status], @scope.available_filters
    assert_nil @scope.to_attributes[:query]
    refute @scope.to_attributes.key?(:filters)
    assert_nil @scope.to_attributes[:filters]
    assert_nil @scope.to_attributes[:order]
    assert_nil @scope.to_attributes[:page]
  end

  def test_that_we_can_initialize_a_new_search_scope
    assert_instance_of Omise::Search, @scope.execute
  end

  def test_that_we_can_filter_a_scope
    scope = @scope.filter(created: "today")

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_nil scope.to_attributes[:query]
    assert scope.to_attributes.key?(:filters)
    assert_instance_of Hash, scope.to_attributes[:filters]
    assert_equal "today", scope.to_attributes[:filters][:created]
    assert_nil scope.to_attributes[:order]
    assert_nil scope.to_attributes[:page]
  end

  def test_that_we_can_filter_a_scope_more_than_once
    scope = @scope.filter(created: "today").filter(status: "failed")

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_nil scope.to_attributes[:query]
    assert scope.to_attributes.key?(:filters)
    assert_instance_of Hash, scope.to_attributes[:filters]
    assert_equal "today", scope.to_attributes[:filters][:created]
    assert_equal "failed", scope.to_attributes[:filters][:status]
    assert_nil scope.to_attributes[:order]
    assert_nil scope.to_attributes[:page]
  end

  def test_that_we_can_query_a_scope
    scope = @scope.query("john")

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_equal "john", scope.to_attributes[:query]
    refute scope.to_attributes.key?(:filters)
    assert_nil scope.to_attributes[:filters]
    assert_nil scope.to_attributes[:order]
    assert_nil scope.to_attributes[:page]
  end

  def test_that_we_can_query_a_scope_more_than_once
    scope = @scope.query("john").query("john doe")

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_equal "john doe", scope.to_attributes[:query]
    refute scope.to_attributes.key?(:filters)
    assert_nil scope.to_attributes[:filters]
    assert_nil scope.to_attributes[:order]
    assert_nil scope.to_attributes[:page]
  end

  def test_that_we_can_order_a_scope
    scope = @scope.order("reverse_chronological")

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_nil scope.to_attributes[:query]
    refute scope.to_attributes.key?(:filters)
    assert_nil scope.to_attributes[:filters]
    assert_equal "reverse_chronological", scope.to_attributes[:order]
    assert_nil scope.to_attributes[:page]
  end

  def test_that_we_can_order_a_scope_more_than_once
    scope = @scope.order("reverse_chronological").order("chronological")

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_nil scope.to_attributes[:query]
    refute scope.to_attributes.key?(:filters)
    assert_nil scope.to_attributes[:filters]
    assert_equal "chronological", scope.to_attributes[:order]
    assert_nil scope.to_attributes[:page]
  end

  def test_that_we_can_page_a_scope
    scope = @scope.page(2)

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_nil scope.to_attributes[:query]
    refute scope.to_attributes.key?(:filters)
    assert_nil scope.to_attributes[:filters]
    assert_nil scope.to_attributes[:order]
    assert_equal 2, scope.to_attributes[:page]
  end

  def test_that_we_can_page_a_scope_more_than_once
    scope = @scope.page(2).page(3)

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_nil scope.to_attributes[:query]
    refute scope.to_attributes.key?(:filters)
    assert_nil scope.to_attributes[:filters]
    assert_nil scope.to_attributes[:order]
    assert_equal 3, scope.to_attributes[:page]
  end

  def test_that_we_can_chain_all_methods_together
    scope = @scope.filter(created: "today")
      .filter(status: "failed")
      .query("john")
      .order("reverse_chronological")
      .page(2)

    refute_equal @scope.object_id, scope.object_id
    assert_equal "charge", scope.scope
    assert_equal "john", scope.to_attributes[:query]
    assert scope.to_attributes.key?(:filters)
    assert_instance_of Hash, scope.to_attributes[:filters]
    assert_equal "today", scope.to_attributes[:filters][:created]
    assert_equal "failed", scope.to_attributes[:filters][:status]
    assert_equal "reverse_chronological", scope.to_attributes[:order]
    assert_equal 2, scope.to_attributes[:page]
  end
end
