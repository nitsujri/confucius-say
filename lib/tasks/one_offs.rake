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

  task :example_english => :environment do
    ap "[Getting Example's Engrish Translations: PIKKACHU!]"
    ap "-- Helps get the translations --"
    OneOffs::GetExampleEnglish.go
  end

  task :process_examples => :environment do
    ap "[Loading Sound Files: KAMEAHMEHA!!!]"
    OneOffs::ProcessExamples.go
  end

  task :link_words => :environment do
    ap "[Linking Words: MATCH 'EM!]"
    OneOffs::LinkWords.go
  end
end