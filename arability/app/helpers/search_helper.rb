module SearchHelper

  # Author: 
  #   Nourhan Zakaria
  # Description:
  #   This is the method that the search button is clicked whether with filters
  #     or not and it get the gender statistics of the voters of certain
  #     synonym then call the piechart method with stats it gets and header to 
  #     represent the stats visually.
  #   The stats may be filtered accroding to certain criteria if filters exists
  # Params:
  #   synonym_id: is the ID of the synonym that the View Stats button clicked
  #     in the view belongs to and this the synonym needed to get the stats 
  #     gender for its voters
  # Success: 
  #   returns a pie chart representing the gender statistics of  
  #     all voters or filtered voters for certain synonym.
  # Failure: 
  #   no chart will be drawn if stats is empty list
  def piechart_gender(synonym_id, gender, country, education, age_from, age_to)
    synonym = Synonym.find(synonym_id)
    stats = synonym
      .get_visual_stats_gender(gender, country, education, age_from, age_to)
    header = t(:stats_gender)
    piechart(stats, header)
  end

  # Author: 
  #   Nourhan Zakaria
  # Description:
  #   This is the method that the search button is clicked whether with filters
  #     or not and it get the country statistics of the voters of certain
  #     synonym then call the piechart method with stats it gets and header to 
  #     represent the stats visually.
  #   The stats may be filtered accroding to certain criteria if filters exists
  # Params:
  #   synonym_id: is the ID of the synonym that the View Stats button clicked
  #     in the view belongs to and this the synonym needed to get the stats 
  #     country for its voters 
  # Success: 
  #   returns a pie chart representing the country statistics of 
  #     all voters or filtered voters for certain synonym.
  # Failure: 
  #   no chart will be drawn if stats is empty list
  def piechart_country(synonym_id, gender, country, education, age_from, age_to)
    synonym = Synonym.find(synonym_id)
    stats = synonym
      .get_visual_stats_country(gender, country, education, age_from, age_to)
    header = t(:stats_country)
    piechart(stats, header)
  end 

  # author:
  #   Mostafa Hassaan
  # description:
  #   function creates the highcharts pie chart
  # params:
  #   keyword_id: id of the keyword needed
  # success:
  #   creates the pie chart in view
  # failure:
  #   fails to show a chart if synonyms have no votes
  def chart_keyword_synonym(keyword_id, synonym_type)
    stats = Keyword.get_keyword_synonym_visual(keyword_id, synonym_type)
    if stats == 0
      @availble = false
    else
      @availble = true
    end
    name1 = Keyword.find(keyword_id).name
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({defaultSeriesType:"pie" , margin: [50, 200, 60, 170]} )
      if I18n.locale == :en
        series = {
                type: 'pie',
                name: 'Browser share',
                data: stats,
        }
      end
      if I18n.locale ==:ar
        series = {
               type: 'pie',
               name: 'Browser share',
               data:  stats,
               dataLabels: {
                    align: 'center',
                    enabled: true,
                    x: 10
                }
      }
        tooltip = {
                  enabled: false
        }
        f.tooltip(tooltip)
      end
      f.series(series)
      f.options[:title][:text] = "#{t(:synonyms_of)} #{name1}"
      f.legend(:layout=> 'vertical', style: {left: 'auto', bottom: 'auto', right: '50px', top: '100px'}) 
      f.plot_options(pie:{
        allowPointSelect: true, 
        cursor: "pointer" , 
        size: '90%',
        align: 'right',
        dataLabels:{
          enabled: true,
          color: "black",
          style: {
            font: "13px Trebuchet MS, Verdana, sans-serif"
        }
      }
    })
  end
  end

  # Author: 
  #   Nourhan Zakaria
  # Description:
  #   This is the method that the search button is clicked whether with filters
  #     or not and it get the age statistics of the voters of certain
  #     synonym then call the piechart method with stats it gets and header to 
  #     represent the stats visually.
  #   The stats may be filtered accroding to certain criteria if filters exists
  # Params:
  #   synonym_id: is the ID of the synonym that the View Stats button clicked
  #     in the view belongs to and this the synonym needed to get the stats 
  #     age for its voters 
  # Success: 
  #   returns a pie chart representing the age statistics of 
  #     all voters or filtered voters for certain synonym.
  # Failure: 
  #   no chart will be drawn if stats is empty list
  def piechart_age(synonym_id, gender, country, education, age_from, age_to)
    synonym = Synonym.find(synonym_id)
    stats = synonym
      .get_visual_stats_age(gender, country, education, age_from, age_to)
    header = t(:stats_age)
    piechart(stats, header)
  end 

  # Author: 
  #   Nourhan Zakaria
  # Description:
  #   This is the method that the search button is clicked whether with filters
  #     or not is and it get the education statistics of the voters of certain
  #     synonym then call the piechart method with stats it gets and header to 
  #     represent the stats visually.
  #   The stats may be filtered accroding to certain criteria if filters exists
  # Params:
  #   synonym_id: is the ID of the synonym that the View Stats button clicked
  #     in the view belongs to and this the synonym needed to get the stats 
  #     education for its voters
  # Success: 
  #   returns a pie chart representing the education statistics of 
  #     voters for certain synonym.
  # Failure: 
  #   no chart will be drawn if stats is empty list
  def piechart_education(synonym_id, gender, country, education, age_from, age_to)
    synonym = Synonym.find(synonym_id)
    stats = synonym
      .get_visual_stats_education(gender, country, education, age_from, age_to)
    header = t(:stats_education)
    piechart(stats, header)
  end 

  # Author: 
  #   Nourhan Zakaria
  # Description:
  #   This is the method that draws the piechart for the given stats and
  #     with the given header.
  # Params:
  #   stats: the list of lists that represents the data that will be 
  #     represented with the piechart
  #   header: the header of the piechart 
  # Success: 
  #   returns a pie chart representing the stats given and
  #     with the given header.
  # Failure: 
  #   no chart will be drawn
  def piechart (stats, header)
    chart = LazyHighCharts::HighChart.new("pie") do |f|
      f.chart({ defaultSeriesType: "pie" , margin: [0, 10, 150, 25], 
      width: 157, hieght: 50 })
      series = {
       type: "pie",
       name: "voters stats",
       borderWidth: 0.7,
       data:  stats         
      }
      f.series(series)
      f.options[:title][:text] = header
      f.options[:title][:x] = 0
      if I18n.locale == :en
        f.options[:title][:style] = {
          fontSize: "14px"
        }
      else
        f.options[:title][:style] = {
          fontSize: "16px"
        }
      end
      f.tooltip = {
        borderColor: "null",
        borderWidth: "6px",
        useHTML: true,
        positioner: { x: 0, y: 0 }
      }
      f.legend(layout: "vertical", style: { left: "0px", 
      bottom: "0px", right: "0px", top: "0px" }) 
      f.plot_options(pie: {
        allowPointSelect: true, 
        cursor: "pointer" ,
        size: '100%', 
        dataLabels: {
          enabled: false,
          color: "black",
          style: {
            font: "13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end
  end

  # author:
  #   Mostafa Hassaan
  # description:
  #   functions gets id of a given keyword
  # params:
  #   word: string of the keyword name needed
  # success:
  #   returns integer of the keyword id
  # failure:
  #   --
  def getID(word)
    return Keyword.where(name: word).first.id
  end

  # author:
  #   Mostafa Hassaan
  # description:
  #   funtion checks whether a developer is following a word or not.
  # params:
  #   key_id: id for the keyword to check
  # success:
  #   returns true if following
  # failure:
  #   returns false if not following
  def is_following(key_id)
    developer = Developer.where(gamer_id: current_gamer.id).first
    keyword_ids = developer.keyword_ids
    keyword_ids.include? key_id.to_i
  end

end

