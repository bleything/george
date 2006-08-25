class FixScoresAndSuch < ActiveRecord::Migration
  def self.up
    puts "-- Recalculating points"
    Address.find_all.each &:recalculate_points!
    
    puts "-- Recalculating scores"
    Geocoding.find_all.each &:calculate_score!
  end

  def self.down
    puts "nothing to do here..."
  end
end
