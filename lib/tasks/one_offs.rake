namespace :one_offs do

  task :individualize_words => :environment do
    ap "[Individualizing Words: Let's go make babies!!]"
    OneOffs::IndividualizeWords.go
  end

  task :verify_words => :environment do
    ap "[Verifying Words: GO GET 'EM!]"
    ap "-- Helps get the sound URLs --"
    OneOffs::VerifyWords.go
  end

  task :link_words => :environment do
    ap "[Linking Words: MATCH 'EM!]"
    OneOffs::LinkWords.go
  end
end