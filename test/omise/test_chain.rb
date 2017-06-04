require "support"

class TestChain < Omise::Test
  setup do
    @chain = Omise::Chain.retrieve("acch_test_57io26ws5af7plco6k1")
  end

  def test_that_we_can_list_all_chains
    chains = Omise::Chain.list

    assert chains
    assert_instance_of Omise::List, chains
    assert_instance_of Omise::Chain, chains.first
  end

  def test_that_we_can_retrieve_a_chain
    chain = Omise::Chain.retrieve("acch_test_57io26ws5af7plco6k1")

    assert chain
    assert_instance_of Omise::Chain, chain
  end

  def test_that_we_can_reload_a_chain
    @chain.attributes.taint
    @chain.reload

    refute @chain.attributes.tainted?
  end

  def test_that_we_can_revoke_a_chain
    @chain.attributes.taint

    refute @chain.revoked

    @chain.revoke

    assert @chain.revoked
    refute @chain.attributes.tainted?
  end
end
