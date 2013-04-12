module SearchHelper

  # Author: Nourhan Zakaria
  # Description:
  #  This is the method that the search view call when button View Stats 
  #  is clicked and it get the gender statistics of the voters of certain
  #  synonym then call the piechart method with stats it gets and header to 
  #  represent the stats visually.
  # Parameters:
  #  synonym_id: is the ID of the synonym that the View Stats button clicked
  #  in the view belongs to and this the synonym needed to get the stats gender
  #  for its voters
  # Returns: 
  #  On success: returns a pie chart representing the gender statistics of  
  #  voters for certain synonym.
  #  On failure: no chart will be drawn 
  def piechart_gender(synonym_id)
    synonym = Synonym.find(synonym_id)
    stats = synonym.get_visual_stats_gender
    header = t(:stats_gender)
    piechart(stats, header)
  end

  # Author: Nourhan Zakaria
  # Description:
  #  This is the method that the search view call when button View Stats 
  #  is clicked and it get the country statistics of the voters of certain
  #  synonym then call the piechart method with stats it gets and header to 
  #  represent the stats visually.
  # Parameters:
  #  synonym_id: is the ID of the synonym that the View Stats button clicked
  #  in the view belongs to and this the synonym needed to get the stats 
  #  country for its voters
  # Returns: 
  #  On success: returns a pie chart representing the country statistics of 
  #  voters for certain synonym.
  #  On failure: no chart will be drawn 
  def piechart_country(synonym_id)
    synonym = Synonym.find(synonym_id)
    stats = synonym.get_visual_stats_country
    header = t(:stats_country)
    piechart(stats, header)
  end 

  # Author: Nourhan Zakaria
  # Description:
  #  This is the method that the search view call when button View Stats 
  #  is clicked and it get the age statistics of the voters of certain
  #  synonym then call the piechart method with stats it gets and header to 
  #  represent the stats visually.
  # Parameters:
  #  synonym_id: is the ID of the synonym that the View Stats button clicked
  #  in the view belongs to and this the synonym needed to get the stats 
  #  age for its voters
  # Returns: 
  #  On success: returns a pie chart representing the age statistics of 
  #  voters for certain synonym.
  #  On failure: no chart will be drawn 
  def piechart_age(synonym_id)
    synonym = Synonym.find(synonym_id)
    stats = synonym.get_visual_stats_age
    header = t(:stats_age)
    piechart(stats, header)
  end 

  # Author: Nourhan Zakaria
  # Description:
  #  This is the method that the search view call when button View Stats 
  #  is clicked and it get the education statistics of the voters of certain
  #  synonym then call the piechart method with stats it gets and header to 
  #  represent the stats visually.
  # Parameters:
  #  synonym_id: is the ID of the synonym that the View Stats button clicked
  #  in the view belongs to and this the synonym needed to get the stats 
  #  education for its voters
  # Returns: 
  #  On success: returns a pie chart representing the education statistics of 
  #  voters for certain synonym.
  #  On failure: no chart will be drawn
  def piechart_education(synonym_id)
    synonym = Synonym.find(synonym_id)
    stats = synonym.get_visual_stats_education
    header = t(:stats_education)
    piechart(stats, header)
  end 


  # Author: Nourhan Zakaria
  # Description:
  #  This is the method that draws the piechart for the given stats and
  #  with the given header.
  # Parameters:
  #  stats: the list of lists that represents the data that will be 
  #  represented with the piechart
  #  header: the header of the piechart
  # Returns: 
  #  On success: returns a pie chart representing the stats given and
  #  with the given header.
  #  On failure: no chart will be drawn
  def piechart (stats, header)
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 10, 150,25], 
      :width => 157, :hieght => 50} )
      series = {
               :type=> 'pie',
               :name=> 'voters stats',
               :borderWidth => 0.7,
               :data=>  stats         
      }
      f.series(series)
      f.options[:title][:text] = header
      f.options[:title][:x] = 0
      f.tooltip = {
        :borderColor => "null",
        :borderWidth => '6px',
        :useHTML => true,
        :positioner => {:x => 0, :y =>0}
      }
      f.legend(:layout=> 'vertical',:style=> {:left=> '0px', 
      :bottom=> '0px',:right=> '0px',:top=> '0px'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" ,
        :size =>'100%', 
        :dataLabels=>{
          :enabled=>false,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end
  end
end