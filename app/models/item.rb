class Item < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 255 }
  validates :point, presence: true, numericality: {only_integer: true}, length: { maximum: 10}
end
