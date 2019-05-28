require "support"

module Omise
  LIST_DATA = JSON.parse(JSON.generate({
    object:   "list",
    location: "/charges",
    offset:   0,
    limit:    20,
    total:    40,
    data:     20.times.map { |i| { object: "charge", id: "chrg_#{i}" } },
  }))

  class Stove < OmiseObject
    def self.list(attributes = {})
      resource(location, attributes)

      List.new(LIST_DATA, options)
    end
  end
end

class TestList < Omise::Test
  setup do
    @parent = Object.new
    @list   = Omise::List.new(Omise::LIST_DATA, parent: @parent)
  end

  def test_that_we_can_initialize_a_list
    assert_instance_of Omise::List, @list
  end

  def test_that_we_can_reload_a_list
    assert @list.reload
  end

  def test_that_we_can_get_the_parent
    assert_equal @parent, @list.parent
  end

  def test_that_we_know_if_we_are_on_the_first_page
    assert make_paginated_list(00, 20, 60).first_page?
    refute make_paginated_list(20, 20, 60).first_page?
    refute make_paginated_list(40, 20, 60).first_page?
  end

  def test_that_we_know_if_we_are_on_the_last_page
    refute make_paginated_list(00, 20, 60).last_page?
    refute make_paginated_list(20, 20, 60).last_page?
    assert make_paginated_list(40, 20, 60).last_page?
  end

  def test_that_we_know_on_which_page_we_are
    assert_equal 1, make_paginated_list(00, 20, 60).page
    assert_equal 2, make_paginated_list(20, 20, 60).page
    assert_equal 3, make_paginated_list(40, 20, 60).page
  end

  def test_that_we_know_how_many_page_there_is
    assert_equal 0, make_paginated_list(00, 20, 00).total_pages
    assert_equal 1, make_paginated_list(00, 20, 10).total_pages
    assert_equal 1, make_paginated_list(00, 20, 20).total_pages
    assert_equal 2, make_paginated_list(00, 20, 30).total_pages
    assert_equal 2, make_paginated_list(00, 20, 40).total_pages
    assert_equal 3, make_paginated_list(00, 20, 50).total_pages
    assert_equal 3, make_paginated_list(00, 20, 60).total_pages
    assert_equal 4, make_paginated_list(00, 20, 70).total_pages
  end

  def test_that_we_can_go_to_the_next_page
    assert_nil make_paginated_list(0, 20, 10).next_page
    assert_instance_of Omise::List, make_paginated_list(0, 20, 30).next_page
  end

  def test_that_we_can_go_to_the_previous_page
    assert_nil make_paginated_list(0, 20, 30).previous_page
    assert_instance_of Omise::List, make_paginated_list(20, 20, 30).previous_page
  end

  def test_that_we_can_go_to_a_specific_page
    assert_nil make_paginated_list(0, 20, 100).jump_to_page(6)
    assert_instance_of Omise::List, make_paginated_list(0, 20, 100).jump_to_page(2)
  end

  def test_we_can_get_enumerate_a_list
    assert_instance_of Enumerator, @list.each
  end

  def test_we_can_get_the_array
    assert_instance_of Array, @list.to_a
    assert_instance_of Omise::Charge, @list.to_a.first
  end

  def test_that_we_can_get_the_last_element_of_the_array
    assert_equal "chrg_19", @list.last.id
  end

  def test_that_subsequent_call_should_retain_api_key
    expected = { key: "pkey_test" }
    list     = Omise::Stove.list(expected.dup)
    list.next_page

    assert_equal expected, list.instance_variable_get(:@options)
  end

  def test_that_different_list_instance_should_use_its_own_key
    expected = { key: "pkey_test_1" }
    list     = Omise::Stove.list(expected.dup)
    list.next_page

    assert_equal expected, list.instance_variable_get(:@options)

    # new list change key
    expected = { key: "pkey_test_2" }
    list     = Omise::Stove.list(expected.dup)
    list.next_page

    assert_equal expected, list.instance_variable_get(:@options)
  end

  def test_that_it_should_use_original_key_when_not_specified
    expected = { key: "pkey_test_1" }
    list     = Omise::Stove.list(expected.dup)
    list.next_page

    assert_equal expected, list.instance_variable_get(:@options)

    # new list, don't specify key, use original key
    expected = { key: Omise.secret_api_key }
    list     = Omise::Stove.list()
    list.next_page

    assert_equal expected, list.instance_variable_get(:@options)
  end

  private

  def make_paginated_list(offset, limit, total)
    attributes = JSON.parse(JSON.generate({
      object:   "list",
      location: "/charges",
      offset:   offset,
      limit:    limit,
      total:    total,
      data:     limit.times.map { { object: "charge" } },
    }))

    Omise::List.new(attributes)
  end
end
