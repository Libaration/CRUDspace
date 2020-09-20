require './app/controllers/images_uploader'

class Images < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, ImagesUploader
end