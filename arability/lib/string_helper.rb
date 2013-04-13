module StringHelper
  # checks if the string is formed of english letters only
  # params:
  #   text: the string being checked
  # returns:
  #   success: returns true if the string is in english
  #   failure: returns false if the string contains non english letters
  def is_english_string(text)
<<<<<<< HEAD
=======
    text = text.strip
    text = text.split(" ").join("")
>>>>>>> dc5e1990bcc6c8c55d943348fd24f42ee3f0e453
    if text.match /^[a-zA-Z]+$/
      true
    else
      false
    end
  end
end
