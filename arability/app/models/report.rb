class Report < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :reported_word, :polymorphic => true 
  belongs_to :gamer
  validates_presence_of :gamer
  validates_presence_of :reported_word
  validates :gamer_id, :uniqueness => { :scope => :reported_word_id,
    :message => "You reported this word before" }

  def self.new_report(gamer, word)
    report = Report.new
    report.reported_word = word
    report.gamer = gamer
    success = report.save
    [success, report]
  end
end