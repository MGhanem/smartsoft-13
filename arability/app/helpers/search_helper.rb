module SearchHelper



  
  # author:
  #   Mostafa Hassaan
  # description:
  #     function creates the highcharts pie chart
  # params:
  #    keyword_id: id of the keyword needed
  # success:
  #     creates the pie chart in view
  # failure:
  #     fails to show a chart if synonyms have no votes
  def chart_keyword_synonym(keyword_id)
    stats = Keyword.get_keyword_synonym_visual(keyword_id)
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
                    x: 40
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

  @@GENDER = 0
  @@COUNTRY = 1
  @@AGE = 2
  @@EDUCATION = 3

  #Author: Nourhan Zakaria
  #This is the method resposible for passing all attributes needed to draw the charts showing the 
  #different statistics of votes for certain synonym.
  #Parameters:
  #  synonym_id: the ID of the synonym that we need to get the statisitics of gamers voted for it.
  #   type: the type decides which attribute we need to get a chart for whether gender statistics, country statistics,
  #   age statistics or educational level statistics.
  #Returns:
  #  On Success: Draw the chart with the attributes soecified.
  #  On Failure: No failure scenario as this method is called only if there's data to br represented by the chart 
  def piechart (synonym_id, type)
    synonym = Synonym.find(synonym_id)
    if type == @@GENDER
      stats = synonym.get_visual_stats_gender
      header = t(:stats_gender)
    elsif type == @@COUNTRY
      stats = synonym.get_visual_stats_country
      header = t(:stats_country)
    elsif type == @@AGE
      stats = synonym.get_visual_stats_age
      header = t(:stats_age)
    else
      stats = synonym.get_visual_stats_education
      header = t(:stats_education)
    end
      chart = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 10, 150,25], :width => 157, :hieght => 50} )
          series = {
                   :type=> 'pie',
                   :name=> 'Browser share',
                   :borderWidth => 0.7,
                   :data=>  stats
          }
          f.series(series)
          f.options[:title][:text] = header
          f.options[:title][:x] = 0

          f.legend(:layout=> 'vertical',:style=> {:left=> '0px', :bottom=> '0px',:right=> '0px',:top=> '0px'}) 
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