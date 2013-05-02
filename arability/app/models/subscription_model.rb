#encoding: UTF-8
class SubscriptionModel < ActiveRecord::Base	has_many :my_subscriptions
  attr_accessible :name_en, :name_ar, :limit_search, :limit_follow, :limit_project ,:limit

  validates_presence_of :name_en, message: "لا يمكن أن يكون الإسم الإنجليزي فارغ"
  validates_presence_of :name_ar, message: "لا يمكن أن يكون الإسم العربي فارغ"
  validates_presence_of :limit_search,
    message: "لا يمكن أن يكون الحد الأقصى للبحث فارغ"
  validates_presence_of :limit_follow,
    message: "لا يمكن أن يكون الحد الأقصى للمتابعة فارغ"
  validates_presence_of :limit_project,
    message: "لا يمكن أن يكون الحد الأقصى للمشاريع فارغ"
  validates_format_of :name_en, with: /^([a-zA-Z ]+)$/,
    message: "هذا الإسم ليس باللغة الإنجليزية"
  validates_format_of :name_ar, with: /^([\u0621-\u0652 ])+$/,
    message: "هذا الإسم ليس باللغة العربية"
  validates_numericality_of :limit_search, only_integer: true,
    greater_than_or_equal_to: 0, message: "يجب أن يكون الحد الاقصى رقم"
  validates_numericality_of :limit_follow, only_integer: true,
    greater_than_or_equal_to: 0, message: "يجب أن يكون الحد الاقصى رقم"
  validates_numericality_of :limit_project, only_integer: true,
    greater_than_or_equal_to: 0, message: "يجب أن يكون الحد الاقصى رقم"
  validates_uniqueness_of :name_en, message: "هذا الإسم الإنجليزي موجود بالفعل"
  validates_uniqueness_of :name_ar, message: "هذا الإسم العربي موجود بالفعل"

  def name
    self.send("name_#{I18n.locale}")
  end

end
