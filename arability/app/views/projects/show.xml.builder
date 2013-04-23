xml.instruct!             # <?xml version="1.0" encoding="UTF-8"?>
@projects = Project.where(:owner_id => current_developer.id)
@project = Project.find(params[:id])
@exported_data = PreferedSynonym.where(project_id: @project.id).all
xml.project_data do
  @exported_data.each do |word|
    @keyword = Keyword.find_by_id(word.keyword_id).name
    @synonym = Synonym.find_by_id(word.synonym_id).name
    xml.word do
      xml.word @keyword
      xml.translation @synonym
    end
  end
end