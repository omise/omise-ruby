require "support"

class TestResource < Omise::Test
  def test_we_can_initialize_a_resource
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")

    assert_instance_of Omise::Resource, resource
  end

  def test_that_the_version_header_is_not_set_if_the_version_config_is_not_set
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")

    assert_instance_of Hash, resource.headers
    assert_nil resource.headers[:omise_version]
  end

  def test_that_the_version_header_is_set_if_the_version_config_is_set
    Omise.api_version = "2014-07-27"
    resource = Omise::Resource.new(Omise.api_url, "/", "skey_xxx")

    assert_instance_of Hash, resource.headers
    assert_equal "2014-07-27", resource.headers[:omise_version]
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
