require 'rubygems'
require "mp3info"

# setting the basedirectory
base_directory = "fertig/"

# run through all directories and get the mp3
Dir["#{base_directory}**/*.mp3"].each do |mp3|
  # get the directory
  arr_directory = mp3.split("/")[0..mp3.split("/").length-2]

  # empty string which will be merged to a string and which is needed for file renaming as a path
  directory_of_album = ""
  arr_directory.each do |part|
    directory_of_album << part + "/"
  end

  directory_of_album = directory_of_album.gsub("//", "/")
  mp3_track = ""

  # open the mp3 to read the id3 infos
  Mp3Info.open(mp3) do |track|
    # write 'Game' for the genre tag
    track.tag2.TCON = "Game"

    # check, if the track title exists
    if track.tag.title != nil
      # mp3 with an underscore are translated in / so we must catch this
      track_string = track.tag.title.gsub("/", "")
      track.tag.title = track_string
    else
      puts "Please set the track-tag for #{mp3.split("/").last} ... NOT converted"
    end
    # save mp3 tag
    mp3_track = track
  end

  # rename files
  if mp3_track.tag.title != nil
    mp3_newname = "#{Dir.pwd}/#{directory_of_album}#{mp3_track.tag.tracknum} - #{mp3_track.tag.title}.mp3"
    output = mp3_newname.split("/")
    File.rename(mp3, mp3_newname)
    puts "#{output[-1]} ... converted [#{mp3_track.tag.album}]"
  end
end
