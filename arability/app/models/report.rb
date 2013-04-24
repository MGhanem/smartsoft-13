class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :reported_word, :polymorphic => true 
  belongs_to :gamer
  validates_presence_of :gamer
  validates_presence_of :reported_word
  validates :gamer_id, :uniqueness => { :scope => :reported_word_id,
    :message => "You reported this word before" }

  # Author:
  #   Nourhan Mohamed
  # Description:
  #   
  # params:
  #   search_keyword: a string representing the search keyword, from the params list
  #     from a textbox in the search view
  # success:
  #   returns a json list of keywords similar to what's currently typed
  #   in the search textbox
  # failure:
  #   returns an empty list if what's currently typed in the search textbox
  #   had no matches
  def self.create_report(gamer, word)
    report = Report.new
    report.reported_word = word
    report.gamer = gamer
    success = report.save
    [success, report]
  end
end