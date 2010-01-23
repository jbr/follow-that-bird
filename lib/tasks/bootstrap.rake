desc "get started"
task :bootstrap => :environment do
  Hashtag.find_or_create_by_tag("haiti")
end