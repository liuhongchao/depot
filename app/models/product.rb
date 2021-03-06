class Product < ActiveRecord::Base
  default_scope :order => 'title'
  
  has_many :line_items, :dependent => :destroy
  before_destroy :ensure_not_referenced_by_any_item

  # validation
  validates :title, :description, :image_url, :presence => true
  validates :title, :uniqueness => true
  validates :image_url, :format => {
    :with    => %r{\.(gif|jpg|png)\z}i,
    :message => 'must be a URL for GIF, JPG or PNG.'
  }
  validates :price, :numericality => {:greater_than_or_equal_to => 0.01}

  def ensure_not_referenced_by_any_item
    if line_items.count.zero?
      return true
    else
      errors.add(:base, 'Line Items present' )
      return false
    end
  end
end
