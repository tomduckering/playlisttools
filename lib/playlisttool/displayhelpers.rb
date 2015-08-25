module DisplayHelpers

  def DisplayHelpers.print_track_stats_for_key(tracks,key_name)
    tracks_with_key    = tracks.select {|track| track.include? key_name}
    tracks_without_key = tracks.reject {|track| track.include? key_name}
    puts "Tracks with #{key_name}: " + tracks_with_key.count.to_s
    puts "Tracks without #{key_name}: " + tracks_without_key.count.to_s
  end

end