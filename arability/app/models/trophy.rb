class Trophy < ActiveRecord::Base
  
  validates :name, :presence => true, :length => { :in => 6..24 },
    :uniqueness => true
  validates :level, :presence => true, :numericality => {
    :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100 }
  validates :score, :presence => true, :numericality => {
    :greater_than_or_equal_to => 1, :less_than_or_equal_to => 1000000 }
  validates :photo, :presence => true
  validates_attachment_size :photo, :in => 0.megabytes..0.5.megabytes
  
  has_and_belongs_to_many :gamers

  attr_accessible :name, :level, :score, :photo

  has_attached_file :photo

  class << self

    # author:
    #     Karim ElNaggar
    # description:
    #     a function adds a new trophy to the database
    # params
    #     name, score, rank, photo
    # success: 
    #     returns true and the new trophy if it is added to the database
    # failure: 
    #     returns false and the trophy if it is not added to the database
    def add_trophy_to_database(name, score, rank, photo)
      new_trophy = Trophy.new(name: name, score: score, level: rank, photo: photo)
      if new_trophy.save
        return true, new_trophy
      else
        return false, new_trophy
      end
    end

  end
end
