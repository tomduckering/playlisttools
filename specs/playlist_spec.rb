require 'rspec'

require_relative "../lib/playlisttool/playlistfiletools"

describe 'playlistfiletools' do

  it 'loads an empty playlist from json' do

    empty_playlist_file = './specs/empty_playlist.json'

    playlist_data = PlaylistFileTools.load_playlist_from_json(empty_playlist_file)

    tracks = playlist_data['tracks']

    expect(tracks).to be_empty
  end

  it 'loads a simple playlist from json' do
    empty_playlist_file = './specs/simple_playlist.json'

    playlist_data = PlaylistFileTools.load_playlist_from_json(empty_playlist_file)

    tracks = playlist_data['tracks']

    expect(tracks).to_not be_empty

  end

  it 'generates md5 for a file' do
    fake_track = './specs/faketrack.wav'

    expected_md5 = 'd41d8cd98f00b204e9800998ecf8427e'

    md5 = PlaylistFileTools.calculate_md5_for_file fake_track

    expect(md5).to eq(expected_md5)

  end

  it 'generates new track data for md5' do

    track = {'file_path' => './specs/faketrack.wav','other_data' => 'should_be_preserved'}

    expected_md5 = 'd41d8cd98f00b204e9800998ecf8427e'

    new_track = PlaylistFileTools.add_md5_to_track_data track

    expect(new_track).to include('file_path')
    expect(new_track).to include('other_data')
    expect(new_track['md5']).to eq(expected_md5)
  end

  it 'detects genre from path' do
    path = '/asdfasdf/asdfasdf/asdf/genre/track.wav'

    detected_genre = PlaylistFileTools.detect_genre path

    expect(detected_genre).to eq('genre')
  end

  it 'does not detect genre from sorting paths' do
    path = '/asdfasdf/asdfasdf/asdf/Z - not a genre/track.wav'

    detected_genre = PlaylistFileTools.detect_genre path

    expect(detected_genre).to be_nil
  end

  it 'gets mixed in key bpm data from file name' do

    path = '/asdfasdf/asdfasdf/asdf/Z - not a genre/110 - 6A - Defkline___Red_Polo_Vs_Dancefloor_-_Wonderfull_World.wav'

    detected_bpm = PlaylistFileTools.detect_bpm path

    expect(detected_bpm).to eq(110)
  end

  it 'gets mixed in key key data from file name' do

    path = '/asdfasdf/asdfasdf/asdf/Z - not a genre/110 - 6A - Defkline___Red_Polo_Vs_Dancefloor_-_Wonderfull_World.wav'

    detected_bpm = PlaylistFileTools.detect_key path

    expect(detected_bpm).to eq("6A")
  end

  it 'gets mixed in key multi key data from file name' do

    path = '/asdfasdf/asdfasdf/asdf/Z - not a genre/110 - 6A or 12B - Defkline___Red_Polo_Vs_Dancefloor_-_Wonderfull_World.wav'

    detected_bpm = PlaylistFileTools.detect_key path

    expect(detected_bpm).to eq("6A or 12B")
  end

  it 'finds asd file for track' do

    path = './specs/faketrack.wav'

    found_asd = PlaylistFileTools.find_ableton_analysis_file path

    expect(found_asd).to eq(path+".asd")

  end


end