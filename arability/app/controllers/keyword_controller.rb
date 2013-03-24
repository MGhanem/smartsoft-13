class KeywordController < ApplicationController
	def approveKeyword
		@keyword = keyword.find(params[:id])
		@keyword.update_attribute(:approved,true)
	end
end
