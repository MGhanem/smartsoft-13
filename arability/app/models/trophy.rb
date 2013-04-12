class Trophy < ActiveRecord::Base
  
  validates :name, :presence => true, :length => { :in => 6..24 },
    :uniqueness => true
  validates_format_of :name, :with =>  /^([\u0621-\u0652 ])+$/
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

  # Description:
  #   returns a list of trophies that the gamer got awarded 
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
  #     an array of the trophies that the gamer won
  #   failure:
  #     no failure
  def self.get_new_trophies_for_gamer(gamer_id, score, level)
    trophies_for_score = []
    gamer = Gamer.find(gamer_id)
    trophies_gamer = gamer.trophies
    trophies_of_level = Trophy.where(:level => level)
    new_trophies = trophies_of_level - trophies_gamer
    new_trophies.map { |nt| trophies_for_score << nt if nt.score <= score }
    trophies_for_score.map { |t| gamer.trophies << t }
    gamer.save
    return trophies_for_score
  end

end

