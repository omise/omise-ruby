require "support"

class TestResource < Omise::Test
  def test_we_can_initialize_a_resource
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")

    assert_instance_of Omise::Resource, resource
  end

  def test_that_the_version_header_is_set_if_the_version_config_is_not_set
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")

    assert_instance_of Hash, resource.headers
    assert_equal "2015-11-17", resource.headers[:omise_version]
  end

  def test_that_the_user_agent_header_has_no_suffix_if_suffix_not_set
    Omise.user_agent_suffix = nil
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")

    assert_equal "OmiseRuby/#{Omise::VERSION} Ruby/#{RUBY_VERSION}", resource.headers[:user_agent]
  end

  def test_that_the_user_agent_header_has_suffix_if_suffix_set
    suffix = "Suffix/1.0"
    Omise.user_agent_suffix = suffix
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")
    assert resource.headers[:user_agent].end_with? suffix
  end

  def test_that_the_path_is_set
    resource = Omise::Resource.new(Omise.api_url, "/charges", "skey_xxx")
    uri = URI.parse("https://api.omise.co/charges")

    assert_equal uri, resource.uri
  end

  def test_that_the_key_is_set
    resource = Omise::Resource.new(Omise.api_url, "/charges", "skey_xxx")

    assert_equal "skey_xxx", resource.key
  end
end
