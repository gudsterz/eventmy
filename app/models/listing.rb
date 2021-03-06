class Listing < ActiveRecord::Base
	if Rails.env.development?
		has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "default.jpg"
	else
		has_attached_file :image, :styles => { :medium => "200x", :thumb => "100x100>" }, :default_url => "default.jpg",
					  :storage => :dropbox,
				      :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
				      :path => ":style/id_:filename"
	end
	validates_attachment_content_type :image, content_type: %w(image/jpeg image/jpg image/png image/gif)
	validates :name, :description, :price, presence: true
	validates :price, numericality: { greater_than_or_equal_to: 0 }

	geocoded_by :address               # can also be an IP address
	after_validation :geocode          # auto-fetch coordinates

	belongs_to :user
	belongs_to :category
	has_many :orders
end
