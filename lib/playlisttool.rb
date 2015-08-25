require "playlisttool/version"
require "playlisttool/cli"

module PlaylistTool

  def PlaylistTool.run(args)
    cli = CLI.start(args)
  end
end
