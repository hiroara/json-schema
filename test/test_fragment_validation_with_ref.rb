require File.expand_path('../test_helper', __FILE__)

class FragmentValidationWithRef < Minitest::Test
  def whole_schema
    {
      "$schema" => "http://json-schema.org/draft-04/schema#",
      "type" => "object",
      "definitions" => {
        "post" => {
          "type" => "object",
          "properties" => {
            "content" => {
              "type" => "string"
            },
            "author" => {
              "type" => "string"
            }
          }
        },
        "posts" => {
          "type" => "array",
          "items" => {
            "$ref" => "#/definitions/post"
          }
        }
      },
      "links" => [
        {
          "title" => "Get a post",
          "rel" => "self",
          "schema" => {
            "$ref" => "#/definitions/post"
          }
        }
      ]
    }
  end

  def test_validation_of_fragment
    data = [{"content" => "ohai", "author" => "Bob"}]
    assert_valid whole_schema, data, :fragment => "#/definitions/posts"
  end

  def test_validation_of_fragment_as_list
    data = [{"content" => "ohai", "author" => "Bob"}]
    assert_valid whole_schema, data, :fragment => "#/definitions/post", list: true
  end

  def test_validation_of_fragment_in_links
    data = {"content" => "ohai", "author" => "Bob"}
    assert_valid whole_schema, data, :fragment => "#/links/0/schema"
  end
end
