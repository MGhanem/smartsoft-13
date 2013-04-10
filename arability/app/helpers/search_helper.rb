module SearchHelper

  #mostafa hassaan
  def chart_keyword_synonym(keyword_id)
    stats = Keyword.get_keyword_synonym_visual(keyword_id)
    name = Keyword.find(keyword_id).name
    chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=>  stats
      }
      f.series(series)
      f.options[:title][:text] = "Synonyms of #{name}"
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
end
