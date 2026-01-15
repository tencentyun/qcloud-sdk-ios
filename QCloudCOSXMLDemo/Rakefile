require "rake"
desc "update local cocoapods"
task :update  do
  Rake::sh "pod update --no-repo-update"
end

desc "default"
task :default => [:update] do
  
end
