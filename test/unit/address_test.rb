require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < Test::Unit::TestCase
  fixtures :addresses, :locations

  # centroid test is from the example given at http://www.saltspring.com/brochmann/math/centroid/centroid.html
  def test_centroid
    acceptable_delta = 0.000000001
    
    addresses(:centroid).recalculate_points!

    assert_in_delta 6.20973782771536, addresses(:centroid).centroid.lat, acceptable_delta
    assert_in_delta 8.65792759051186, addresses(:centroid).centroid.long, acceptable_delta
  end
  
  def test_centroid_single_point
    addresses(:single_point).recalculate_points!

    assert_equal 50, addresses(:single_point).centroid.lat
    assert_equal 30, addresses(:single_point).centroid.long
  end
  
  def test_centroid_two_points
    addresses(:two_points).recalculate_points!

    assert_equal 55, addresses(:two_points).centroid.lat
    assert_equal 15, addresses(:two_points).centroid.long
  end
end
