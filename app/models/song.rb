class Song < ActiveRecord::Base
  belongs_to :user
  mount_uploader :profilesong, ImagesUploader
end
