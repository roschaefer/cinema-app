module ActiveCinema
  def self.start_video
    @start_video ||= nil
  end

  def self.start_with(video)
    @start_video = video
    set_current(video)
  end

  def self.set_current(video)
    @current_video = video
  end

  def self.the_video
    @current_video ||= nil
  end

  class App < Sinatra::Application

    def self.check_video_file_exists(id, file)
      #if file.nil?
        #abort("Node #{id}: No video file!'")
      #end
      #path = Pathname.new(settings.root).join("public").join("videos").join(file)
      #unless File.exists?(path)
        #abort("Node #{id}: No corresponding file in '#{path}'")
      #end
    end

    def self.create_videos
      all_videos = {}

      settings.video.each do |id, hash|
        file = hash['file']
        check_video_file_exists(id, file)

        stream = ENV['RACK_ENV'] == "production" ? settings.remote_url + file + "&download" : "videos/" + file
        video = Video.new(id, stream)
        all_videos[id] = video
      end
      all_videos
    end

    def self.connect_videos(all_videos)
      all_videos.each do |id, video|
        sequels = {}
        unless settings.video[id]['sequels'].nil?
          settings.video[id]['sequels'].each do |answer_key, sequel_id|
            sequels[answer_key] = all_videos[sequel_id]
          end
        end
        question = settings.video[id]['question']
        answers   = settings.video[id]['answers']
        video.connect(question, answers, sequels)
      end
    end

    def self.check_config_file_is_not_empty
      unless settings.respond_to?(:video)
        abort("Configuration file is invalid: Please add a key 'video'.")
      end
    end

    check_config_file_is_not_empty
    all_videos = create_videos
    connect_videos(all_videos)
    start = all_videos["v1"]

    ActiveCinema.start_with(start)
  end
end
