class SynonymController < ApplicationController
	def approveSynonym
		@synonym = Synonym.find(params[:id])
		@synonym.update_attribute(:approved,true)
	end
end
