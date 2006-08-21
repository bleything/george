require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < Test::Unit::TestCase
  fixtures :addresses, :geocodings

  # centroid test is from the example given at http://www.saltspring.com/brochmann/math/centroid/centroid.html
  def test_centroid
    acceptable_delta = 0.000000001

    assert_in_delta 6.20973782771536, addresses(:centroid).centroid[0], acceptable_delta
    assert_in_delta 8.65792759051186, addresses(:centroid).centroid[1], acceptable_delta
  end
end
