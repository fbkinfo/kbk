namespace :app do
  desc "Cleanup models"
  task cleanup: :environment do
    Photo.cleanup
    Snapshot.cleanup
  end
end
