class KeywordController < ApplicationController
	def approveKeyword
		@keyword = Keyword.find(params[:id])
		@keyword.update_attribute(:approved,true)
	end
end
