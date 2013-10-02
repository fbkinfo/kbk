require 'spec_helper'
require 'carrierwave/limited_filename'

class UploadableModel < ActiveRecord::Base
end

class FakeUploader < CarrierWave::Uploader::Base
  include CarrierWave::LimitedFilename

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end

describe CarrierWave::LimitedFilename do
  before(:all) do
    ActiveRecord::Base.connection.create_table :uploadable_models do |t|
      t.string :title
    end

    long_name = "foobar" * 12
    @long_file = Rails.root.join("spec/fixtures").join("#{long_name}.jpg")

    FileUtils.cp(FileFixtures.photo_path, @long_file)
  end

  after(:all) do
    FileUtils.rm(@long_file)

    ActiveRecord::Base.connection.drop_table :uploadable_models
  end

  it "limits filename" do
    model = UploadableModel.create!

    uploader = FakeUploader.new(model)
    uploader.store!(File.open(@long_file))

    allowed_size = CarrierWave::LimitedFilename::MAX_FILENAME_LENGTH
    expect(uploader.filename.size).to eq allowed_size + 4
  end
end