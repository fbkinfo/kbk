require 'fileutils'

namespace :app do
  task :bootstrap_deploy do
    if File.directory?("deploy")
      FileUtils.symlink "deploy/Capfile", "Capfile"
      FileUtils.symlink "../deploy/deploy.rb", "config/deploy.rb"

      FileUtils.mkdir_p "config/deploy"

      FileUtils.symlink "../../deploy/production.rb", "config/deploy/production.rb"
      FileUtils.symlink "../../deploy/staging.rb", "config/deploy/staging.rb"
    end
  end
end
