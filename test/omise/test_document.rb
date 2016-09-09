require "support"

class TestDocument < Omise::Test
  setup do
    @documents = Omise::Dispute.retrieve("dspt_test_5089off452g5m5te7xs").documents
    @document = @documents.retrieve("docu_test_55869onwfm2g3bsw8d8")
  end

  def test_that_we_can_retrieve_a_document
    assert_instance_of Omise::Document, @document
    assert_equal "docu_test_55869onwfm2g3bsw8d8", @document.id
  end

  def test_that_we_can_upload_a_new_document
    document = @documents.upload(StringIO.new)

    assert_instance_of Omise::Document, document
    assert_equal "docu_test_55869onwfm2g3bsw8d8", document.id
  end

  def test_that_a_document_can_be_reloaded
    @document.attributes.taint
    @document.reload

    refute @document.attributes.tainted?
  end

  def test_that_we_can_destroy_a_document
    @document.destroy

    assert @document.deleted
  end
end
