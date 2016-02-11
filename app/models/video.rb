class Video
  attr_reader :name
  attr_reader :stream
  attr_reader :sequels
  attr_reader :question
  attr_reader :answers

  def initialize(name, stream)
    @name     = name
    @stream   = stream
  end

  def connect(question, answers, sequels)
    @question = question
    @answers  = answers
    @sequels  = sequels

    sequels.each do |answer_key, sequel_video|
      if sequel_video.nil?
        abort("Node #{name}: Couldn't find a sequel for answer  '#{answer_key}'.")
      end
    end
  end

end
