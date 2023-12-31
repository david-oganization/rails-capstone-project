class Item < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :group_items
  has_many :groups, through: :group_items

  include ImageUploader::Attachment(:icon)

  validates :name, presence: true
  validates :amount, presence: true, numericality: { only_integer: true, other_than: 0 }

  def add_group
    groups.length ||= 0
  end

  def add_unique_group(item)
    groups << item unless groups.include?(item)
  end
end
