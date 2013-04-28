class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :reported_word, polymorphic: true 
  belongs_to :gamer
  validates_presence_of :gamer
  validates_presence_of :reported_word
  validates :gamer_id, uniqueness: { scope: 
    [:reported_word_id, :reported_word_type],
    message: "You reported this word before" }

  # Author:
  #   Nourhan Mohamed
  # Description:
  #   creates a new report for either a keyword or a synonym
  # params:
  #   gamer: the gamer who requested the report
  #   word: the reported synonym or keyword
  # success:
  #   returns true and an instance of the created report upon success
  # failure:
  #   returns false and a non saved instance of the report
  def self.create_report(gamer, word)
    report = Report.new
    report.reported_word = word
    report.gamer = gamer
    success = report.save
    [success, report]
  end
end