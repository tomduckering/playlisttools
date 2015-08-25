module PlaylistStats

  def track_count(playlist_data)
    return playlist_data['tracks'].count
  end

end