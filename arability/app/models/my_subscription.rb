 class MySubscription < ActiveRecord::Base
  belongs_to :subscription_model
  attr_accessible :developer, :word_add, :word_follow, :word_search, :subscription_model_id
  belongs_to :developer
  validates :subscription_model_id, presence: true
  # Author:
  #   Noha Hesham
  # Description:
  #  it finds the chosen subscription model by the developer
  #  and sets the limits in the subscription model
  #  to the developers my subscription
  # success:
  #  the limits are set in the my subscription of the developer
  # failure:
  #  the limits are not put in the my subscription of the developer
  def self.choose(dev_id,sub_id)
    if sub_id == nil || dev_id == nil
      return false
    end
    submodel = SubscriptionModel.find(sub_id)
    my_sub = MySubscription.where(:developer_id => dev_id).first
    if(my_sub == nil)
      my_sub = MySubscription.new
    end
    my_sub.developer_id = dev_id
    my_sub.word_search = submodel.limit_search
    my_sub.word_add = submodel.limit
    my_sub.word_follow = submodel.limit_follow
    my_sub.project = submodel.limit_project
    my_sub.subscription_model_id = submodel.id
    if my_sub.save
      return true
    else
      return false
    end
  end

  # Author:
  #   Noha hesham
  # Description:
  #   Returns true if the followed words are less
  #   than the follow limit,false otherwise
  # Params:
  #   None
  # Success:
  #   Permission is given if the developer didnt exceed the follow limit
  # Failure:
  #   None
  def get_permission_follow
    developer = self.developer
    count_follow = developer.keywords.count
    if(count_follow < self.word_follow)
      return true
    else
      return false
    end
  end

  # Author:
  #  Noha Hesham
  # Description:
  #  Counts the number of the followed word by the
  #  developer till now
  # Params:
  #   None
  # Success:
  #  Gets the correct number of words counted
  # Failure:
  #  None
  def count_follow
    developer = self.developer
    count_follow = developer.keywords.count
  end

  # Author:
  #   Noha Hesham
  # Description:
  #   It compares the created projects with the developer's project
  #   limit and returns true if the developer didnt pass the limit
  # Params:
  #   None
  # Success:
  #   Gives permission
  # Failure:
  #   None
  def get_projects_limit
    developer = self.developer
    projects_count = Project.where(owner_id: developer.id).count
    if(projects_count < self.project)
      return true
    else
      return false
    end
  end

  # Author:
  #   Noha Hesham
  # Description:
  #   It compares the words added by the developer to the add
  #   limit and returns true if the developer didnt pass the limit
  # Params:
  #   Proj_id is the id of the project
  # Success:
  #   Gives permission to add words
  # Failure:
  #   None
  def can_add_word(proj_id)
    developer = self.developer
    add=PreferedSynonym.where(project_id: proj_id)
    if add.count < self.word_add
      return true
    else
      return false
    end
  end

  # Author:
  #   Noha Hesham
  # Description:
  #   It compares the words added by the developer to the add
  #   limit and returns the number of words remaining
  # Params:
  #   Proj_id is the id of the project
  # Success:
  #   Returns number of words
  # Failure:
  #   None
  def can_add_word_count(proj_id)
    developer = self.developer
    add = PreferedSynonym.where(project_id: proj_id ).count
    count_num = self.word_add-add
    return count_num
  end

  # Author:
  #   Noha Hesham
  # Description:
  #   It takes the word id and checks if the developer has searched for it before
  #   if no it checks if the developer has passed the search limit and
  #   gives permission accordingly
  # Params:
  #   word_id is the id of the keyword
  # Success:
  #   Gives permission to search
  # Failure:
  #   None
  def can_search_word(word_id)
    developer = self.developer
    word = Search.where(keyword_id: word_id).first
    if word!= nil
      return true
    else
      if self.word_search > Search.where(developer_id: self.developer_id).count
        search = Search.new
        search.developer_id = developer.id
        search.keyword_id = word_id
        search.save
        return true
      else
        return false
      end
    end
  end
end