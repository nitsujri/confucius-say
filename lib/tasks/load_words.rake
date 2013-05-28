namespace :load_words do
  task :jyutping => :environment do
    ap "[Loading Jyutping, It's wut ur mama wants! DIUUUUUUUUUUU]"
    WordLoader::LoaderJyutping.go
  end

  task :pinyin => :environment do
    ap "[Loading Pinyin, Biches!]"
    WordLoader::LoaderPinyin.go
  end
end