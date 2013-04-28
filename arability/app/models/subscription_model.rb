#encoding: UTF-8
class SubscriptionModel < ActiveRecord::Base
  has_many :my_subscriptions
  attr_accessible :name, :limit_search, :limit_follow, :limit_project

  validates_presence_of :name, message: "لا يمكن أن يكون الإسم فارغ"
  validates_presence_of :limit_search,
    message: "لا يمكن أن يكون الحد الأقصى للبحث فارغ"
  validates_presence_of :limit_follow,
    message: "لا يمكن أن يكون الحد الأقصى للمتابعة فارغ"
  validates_presence_of :limit_project,
    message: "لا يمكن أن يكون الحد الأقصى للمشاريع فارغ"
  validates_format_of :name, with: /^([a-zA-Z ]+)$/,
    message: "هذا الإسم ليس باللغة الإنجليزية"
  validates_numericality_of :limit_search, only_integer: true,
    greater_than_or_equal_to: 0, message: "يجب أن يكون الحد الاقصى رقم"
  validates_numericality_of :limit_follow, only_integer: true,
    greater_than_or_equal_to: 0, message: "يجب أن يكون الحد الاقصى رقم"
  validates_numericality_of :limit_project, only_integer: true,
    greater_than_or_equal_to: 0, message: "يجب أن يكون الحد الاقصى رقم"
  validates_uniqueness_of :name, message: "هذا الإسم موجود بالفعل"

end