require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < Test::Unit::TestCase
  fixtures :addresses, :geocodings

  # centroid test is from the example given at http://www.saltspring.com/brochmann/math/centroid/centroid.html
  def test_centroid
    assert_equal [6.20973782772, 8.6579275905], addresses(:centroid).centroid
  end
end
