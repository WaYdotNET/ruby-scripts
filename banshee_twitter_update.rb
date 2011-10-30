require "rubygems"
require "twitter"

def get_album
  album = `banshee --query-album`
  remove_line_breaks(album.gsub("album: ",""))
end

def get_artists
  artists = `banshee --query-artist`
  artists_array = artists.split(',')
  artists = ""
  size = artists_array.size
  counter = 1
  artists_array.each do |el|
    if size == 1
      artists << "#{el}"
    elsif counter == size
      artists << ", and#{el}"
    elsif counter == 1
      artists << el
      counter += 1
    else
      artists << ",#{el}"
      counter +=1
    end
  end
  remove_line_breaks(artists.gsub("artist: ", ""))
end

def remove_line_breaks(str)
  str.gsub("\n","")
end

def update_message
  message = "Listening to \"#{get_album}\" by #{get_artists}.".gsub("\n","")
  prepare_sending(message)
end

def prepare_sending(message)
  number = message.size
  if number > 140
    puts "Sorry, but message is to long (contains #{number}), we leave the artists away."
    message = "Listening to \"#{get_album}\"."
    Twitter.configure do |config|
      config.consumer_key = ""
      config.consumer_secret = ""
      config.oauth_token = "89908942-KcTurOZhtBoolFj17C5125CtydtxB9MtcO9CAYrc"
      config.oauth_token_secret = "x7T9887g1FhuvhRZnGjLOCIqTNXAc4NxbpDG74aqc4E"
    end
    client = Twitter::Client.new
    client.update(message)
  else
    puts "Yes, the size is of the update-message is #{number}"
    puts "The message:\n   #{message}\nwill be posted on your twitter account."
    Twitter.configure do |config|
      config.consumer_key = ""
      config.consumer_secret = ""
      config.oauth_token = "89908942-KcTurOZhtBoolFj17C5125CtydtxB9MtcO9CAYrc"
      config.oauth_token_secret = "x7T9887g1FhuvhRZnGjLOCIqTNXAc4NxbpDG74aqc4E"
    end
    client = Twitter::Client.new
    client.update(message)
  end
end

update_message
