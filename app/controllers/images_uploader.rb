class ImagesUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
  storage :file
end