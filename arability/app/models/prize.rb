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
  validates :image, :presence => true
  validates_attachment_size :image, :in => 0.megabytes..0.5.megabytes
  
  has_and_belongs_to_many :gamers

  attr_accessible :name, :level, :score, :image

  has_attached_file :image

  class << self
    
    # author:
    #     Karim ElNaggar
    # description:
    #     a function adds a new prize to the database
    # params
    #     name, score, rank, image
    # success: 
    #     returns true and the new prize if it is added to the database
    # failure: 
    #     returns false and the prize if it is not added to the database
    def add_prize_to_database(name, score, rank, photo)
      new_prize = Prize.new(name: name, score: score, level: rank, image: photo)
      if new_prize.save
        return true, new_prize
      else
        return false, new_prize
      end
    end



  def get_new_prizes_for_gamer(gamer_id, score, level)
    prizes_all = Prize.where(:score => score, :level => level)
    prizes_gamer = Gamer.find(gamer_id).prizes
    return prizes_all - prizes_gamer
  end

end
