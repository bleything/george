require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < Test::Unit::TestCase
  fixtures :addresses, :locations

  # centroid test is from the example given at http://www.saltspring.com/brochmann/math/centroid/centroid.html
  def test_centroid
    acceptable_delta = 0.000000001

    assert_in_delta 6.20973782771536, addresses(:centroid).centroid[0], acceptable_delta
    assert_in_delta 8.65792759051186, addresses(:centroid).centroid[1], acceptable_delta
  end
  
  def test_centroid_single_point
    assert_equal 50, addresses(:single_point).centroid[0]
    assert_equal 30, addresses(:single_point).centroid[1]
  end
  
  def test_centroid_two_points
    assert_equal 55, addresses(:two_points).centroid[0]
    assert_equal 15, addresses(:two_points).centroid[1]
  end
end
