module SearchHelper

  @@GENDER = 0
  @@COUNTRY = 1
  @@AGE = 2
  @@EDUCATION = 3

  def piechart (synonym_id, type)
    if type == @@GENDER
      stats = Synonym.get_visual_stats_gender(synonym_id)
    elsif type == @@COUNTRY
      stats = Synonym.get_visual_stats_country(synonym_id)
    elsif type == @@AGE
      stats = Synonym.get_visual_stats_age(synonym_id)
    else
      stats = Synonym.get_visual_stats_education(synonym_id)
    end
      chart = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie" , :margin=> [0, 10, 150,0], :width => 150, :hieght => 50} )
          series = {
                   :type=> 'pie',
                   :name=> 'Browser share',
                   :borderWidth => 0.7,
                   :data=>  stats
                  
                   
          }
          f.series(series)
          f.options[:title][:text] = "THA PIE"
          f.options[:title][:x] = -10

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

    def newChart(synonym_id)
      stats = Synonym.get_visual_stats_gender(synonym_id)
      require 'gchart'
      pc = Gchart.pie(:data => stats, :labels => labels, :size => '695x380')
      @graph = pc.to_url


    end
end
