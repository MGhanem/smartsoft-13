class Search < ActiveRecord::Base
  attr_accessible :developer_id, :synonym_id

 #def count_search
  	#@count = Searches.count("developer_id",:conditions => "developer_id=current_user_id")
#end
end
