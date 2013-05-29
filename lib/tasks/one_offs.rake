namespace :one_offs do

  task :individualize_words => :environment do
    ap "[Individualizing Words: Let's go make babies!!]"
    OneOffs::IndividualizeWords.go
  end
end