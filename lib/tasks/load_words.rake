namespace :load_words do
  task :jyutping => :environment do
    WordLoader::LoaderJyutping.go
  end

  task :pinyin => :environment do
    WordLoader::LoaderPinyin.go
  end
end