# encoding: UTF-8
module ApplicationHelper
  
  # USAGE:
  # To include any of these helper methods in your controllers make 
  # sure you write "include ApplicationHelper" at the top of the file

  # Checks if current signed in gamer has a developer account
  # author:
  #   Adam Ghanem, Salma Farag
  # params:
  #   none
  # returns:
  #   true if the gamer has a developer account otherwise false
  def developer_signed_in?
    Developer.find_by_gamer_id(current_gamer.id) != nil
  end

  # returns the actual developer instance that is currently logged in
  # author:
  #   Adam Ghanem
  # params:
  #   none
  # returns:
  #   success: returns the current developer that is signed in
  #   failure: returns nil
  def current_developer
    Developer.find_by_gamer_id(current_gamer.id)
  end

  def developer_unauthorized
    flash.now[:error] = "You are not authorized to view this page" 
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   returns country name based on locale
  # Params:
  #   country: the english name for country
  # Success: 
  #   arabic or english name country
  # Failure:
  #   none
  def get_country_name_by_locale(country)
    countries = [['مصر','Egypt'],['لبنان','Lebanon'],
    ['الاردن','Jordan'],['السعودية','Saudi Arabia'],['ليبيا','Libya'],['الامارات','United Arab Emirates'],['قطر','Qatar'],['الكويت','Kuwait'],
    ['العراق','Iraq'],['الجزأئر','Algeria'],['المغرب','Morocco'],['البحرين','Bahrain'],
    ['موريتانيا','mauritania'],['الصومال','Somalia'],['السودان','Sudan'],['تونس','Tunisia'],
    ['اخري','others']]
    countries.each do |c|
      if c[1] == country
        if I18n.locale == :ar
          return c[0]
        else
          return c[1]
        end
      end
    end
    if I18n.locale == :ar
      return "ليس محدد"
    else
      return "None"
    end
  end

  # Author:
  #   Mohamed Tamer
  # Description
  #   returns education level based on locale
  # Params:
  #   education_level: the english name for education_level
  # Success: 
  #   arabic or english name of education level
  # Failure:
  #   none
  def get_education_level_by_locale(education_level)
    education_levels = [['خريج','Graduate'],['طالب جامعي','University'],['طالب مدرسة','School']]
    education_levels.each do |c|
      if c[1] == education_level
        if I18n.locale == :ar
          return c[0]
        else
          return c[1]
        end
      end
    end
    if I18n.locale == :ar
      return "ليس محدد"
    else
      return "None"
    end
  end
end
