require 'json'
require 'digest/md5'

module PlaylistFileTools


  def PlaylistFileTools.load_playlist_from_json(playlist_file_path)

    file = File.read(playlist_file_path)
    playlist_data = JSON.parse(file)

    return playlist_data

  end

  def PlaylistFileTools.save_playlist_to_file(playlist_data,playlist_file)
    File.open(playlist_file,"w") do |f|
      f.write(JSON.pretty_generate(playlist_data))
    end
  end

  def PlaylistFileTools.calculate_md5_for_file(file_path)
    Digest::MD5.hexdigest(File.read(file_path))
  end

  def PlaylistFileTools.add_md5_to_track_data(track)
    track['md5'] = PlaylistFileTools.calculate_md5_for_file(track['file_path'])
    return track
  end

  def PlaylistFileTools.detect_genre(file_path)
    containing_path = File.dirname(file_path)

    top_directory = File.basename(containing_path)

    if top_directory.start_with?("Z -")
      return nil
    else
      return top_directory
    end
  end

  @@regex = /(\d*) - ((\d+[AB])( or \d+[AB])*) - (.*)/


  def PlaylistFileTools.detect_bpm(file_path)
    basename = File.basename(file_path)



    match = basename.match(@@regex)

    if match
      return match.captures[0].to_i
    else
      return nil
    end
  end

  def PlaylistFileTools.detect_key(file_path)
    basename = File.basename(file_path)

    match = basename.match(@@regex)

    if match
      return match.captures[1]
    else
      return nil
    end
  end

  def PlaylistFileTools.genre_from_directory_name(tracks)
    new_tracks = tracks.map do |track|

      genre = PlaylistFileTools.detect_genre(track['file_path'])

      if ! genre.nil?
        track['genre'] = genre
      end
      track

    end

    return new_tracks
  end

  def PlaylistFileTools.mik_data_from_file_name(tracks)
    new_tracks = tracks.map do |track|

      bpm = PlaylistFileTools.detect_bpm(track['file_path'])
      key = PlaylistFileTools.detect_key(track['file_path'])

      if ! bpm.nil?
        track['bpm'] = bpm
      end

      if ! key.nil?
        track['key'] = key
      end
      track

    end

    return new_tracks
  end


  def PlaylistFileTools.calculate_md5_for_playlist(tracks)
    new_tracks = tracks.map do |track|

      if ! track.include?('md5') || track['md5'].empty?
        track = PlaylistFileTools.add_md5_to_track_data(track)
      end
      track

    end

    return new_tracks

  end

  def PlaylistFileTools.look_for_asds(tracks)
    new_tracks = tracks.map do |track|

      asd_file = PlaylistFileTools.find_ableton_analysis_file(track['file_path'])

      if ! asd_file.nil?
        track['asd_file'] = asd_file
      end
      track

    end

    return new_tracks
  end

  def PlaylistFileTools.find_ableton_analysis_file(file_path)
    directory = File.dirname(file_path)

    base_file = File.basename(file_path)

    asd_file = base_file + ".asd"

    asd_file_path = File.join(directory,asd_file)

    if File.exist? asd_file_path
      return asd_file_path
    else
      return nil
    end

  end

end