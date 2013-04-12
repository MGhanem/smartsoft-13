class Prize < ActiveRecord::Base
    
    validates :name, :presence => true, :length => { :in => 6..24 }, 
      :uniqueness => true
    validates_format_of :name, :with => /^([\u0621-\u0652 ])+$/
    validates :level, :presence => true, :numericality => { 
      :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100 }
    validates :score, :presence => true, :numericality => { 
      :greater_than_or_equal_to => 1, :less_than_or_equal_to => 1000000 }
                                # This will probably be changed when we figure
                                # the scoring system the game will have
    # validates :photo, :presence => true
    # validates_attachment_size :photo, :in => 0.megabytes..0.5.megabytes
    
    has_and_belongs_to_many :gamers

    attr_accessible :name, :level, :score, :photo

    # has_attached_file :photo
    
    # Description:
    #   returns a list of prizes that the gamer got awarded 
    #   and awards it to the current_gamer
    # Author:
    #   Adam Ghanem
    # @params:
    #   gamer_id: the gamer id of the current signed in gamer
    #   score: the score that was just scored in the game
    #   level: the level that the gamer was on before the method was
    #          called
    # returns:
    #   success:
    #     an array of the prizes that the gamer won
    #   failure:
    #     no failure
    def self.get_new_prizes_for_gamer(gamer_id, score, level)
      prizes_for_score = []
      gamer = Gamer.find(gamer_id)
      prizes_gamer = gamer.prizes
      prizes_of_level = Prize.where(:level => level)
      new_prizes = prizes_of_level - prizes_gamer
      new_prizes.map { |np| prizes_for_score << np if np.score <= score }
      prizes_for_score.map { |p| gamer.prizes << p }
      gamer.save
      return prizes_for_score
    end

end
