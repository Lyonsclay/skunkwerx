class Product < ActiveRecord::Base
  has_many :line_items
  before_destroy :check_if_has_no_line_items
  validates :name, :description, :quantity, :unit_cost, presence: true
  validates :unit_cost, numericality: {greater_than_or_equal_to: 0.01}
  validates :name, uniqueness: true
  # validates :image, allow_blank: true, format: {
  #   with: %r{\.(gif|jpg|png)\Z}i,
  #   message: 'must be a URL for GIF, JPG or PNG image.'
  # }

  # This method associates the attribute ":image" with a file atachment
  has_attached_file :image,
    styles: {
      thumb: '100x100#',
      square: '200x200#',
      medium: '300x300#'
    },
    default_url: ':style/missing.png',
    bucket: ENV['S3_BUCKET_NAME'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']

  validates_attachment_file_name :image, :matches => [/(gif|jp?g|png)\Z/i]
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # For caching
  def self.latest
    Product.order(:updated_at).latest
  end

  def self.search(search)
    if search
      # Method #where returns ActiveRecord::Relation which is chainable with
      # other query methods including gem 'kaminari' method #page.
      # where('lower(name) LIKE ?', "%#{search.downcase}%")
      where("name @@ :q or description @@ :q", q: search)
    else
      find(:all)
    end
  end

  private

    # Ensure that there are no line_items referencing this product
    def check_if_has_no_line_items
      if line_items.empty?
        return true
      else
        errors.add(:base, 'Line Items present')
        return false
      end
    end
end
