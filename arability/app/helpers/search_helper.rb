module SearchHelper

  @@GENDER = 0
  @@COUNTRY = 1
  @@AGE = 2
  @@EDUCATION = 3

  def chart_keyword_synonym(keyword_id)
    stats = Keyword.get_keyword_synonym_visual(keyword_id)
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=>  stats
      }
      f.series(series)
      f.options[:title][:text] = ""
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" , 
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end
  end



  def piechart (synonym_id, type)
    if type == @@GENDER
      stats = Synonym.get_visual_stats_gender(synonym_id)
      header = t(:stats_gender)
    elsif type == @@COUNTRY
      stats = Synonym.get_visual_stats_country(synonym_id)
      header = t(:stats_country)
    elsif type == @@AGE
      stats = Synonym.get_visual_stats_age(synonym_id)
      header = t(:stats_age)
    else
      stats = Synonym.get_visual_stats_education(synonym_id)
      header = t(:stats_education)
    end
      chart = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 10, 150,25], :width => 150, :hieght => 50} )
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
