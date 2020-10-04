class ImagesUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w(jpg jpeg gif png mp3)
  end
  storage :file
end