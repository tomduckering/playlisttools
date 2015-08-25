require 'thor'
require_relative "../playlisttool/playlistfiletools"
require_relative "displayhelpers"

class CLI < Thor

  desc "md5 playlist.json", "generate MD5 hashes for tracks"
  def md5(playlist_file)

    playlist_data = PlaylistFileTools.load_playlist_from_json playlist_file

    tracks = playlist_data['tracks']

    tracks_with_no_md5 = tracks.reject {|track| track.include? "md5"}

    puts "Track Count: #{tracks.count}"

    DisplayHelpers.print_track_stats_for_key(tracks, 'md5')

    new_tracks = PlaylistFileTools.calculate_md5_for_playlist(tracks)


    playlist_data['tracks'] = new_tracks

    PlaylistFileTools.save_playlist_to_file(playlist_data,playlist_file)

  end

  desc "text2json tracks.txt", "generate a basic json playlist from a list of track files"
  def text2json(tracks_file)

    contents = File.readlines(tracks_file)

    file_paths = contents.select {|line| line.start_with?('/')}

    tracks = file_paths.map {|file_path| {'file_path' => file_path.chomp}}

    playlist_data = {'tracks' => tracks}

    base_filename = File.basename(tracks_file,File.extname(tracks_file))

    playlist_file = base_filename + ".json"

    directory = File.dirname(tracks_file)

    playlist_file_path = File.join(directory,playlist_file)

    PlaylistFileTools.save_playlist_to_file(playlist_data,playlist_file_path)

  end

  desc "genre_from_directory playlist.json", "Determine genre from directory"
  def genre_from_directory(playlist_file)

    playlist_data = PlaylistFileTools.load_playlist_from_json playlist_file

    tracks = playlist_data['tracks']

    new_tracks = PlaylistFileTools.genre_from_directory_name(tracks)


    playlist_data['tracks'] = new_tracks

    DisplayHelpers.print_track_stats_for_key(new_tracks,'genre')

    PlaylistFileTools.save_playlist_to_file(playlist_data,playlist_file)

  end



  desc "mik_from_filename playlist.json", "Determine BPM and key from filename"
  def mik_from_filename(playlist_file)

    playlist_data = PlaylistFileTools.load_playlist_from_json playlist_file

    tracks = playlist_data['tracks']

    new_tracks = PlaylistFileTools.mik_data_from_file_name(tracks)


    playlist_data['tracks'] = new_tracks

    DisplayHelpers.print_track_stats_for_key(new_tracks, 'bpm')
    DisplayHelpers.print_track_stats_for_key(new_tracks, 'key')

    PlaylistFileTools.save_playlist_to_file(playlist_data,playlist_file)

  end

  desc "find_asd playlist.json", "Find Ableton ASD files"
  def find_asd(playlist_file)

    playlist_data = PlaylistFileTools.load_playlist_from_json playlist_file

    tracks = playlist_data['tracks']

    new_tracks = PlaylistFileTools.look_for_asds(tracks)


    playlist_data['tracks'] = new_tracks

    DisplayHelpers.print_track_stats_for_key(new_tracks, 'asd_file')

    PlaylistFileTools.save_playlist_to_file(playlist_data,playlist_file)

  end

end