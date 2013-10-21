module SearchHelper
  def build_jyutping(full_word)

    return unless full_word.jyutping.present? 

    split = full_word.jyutping.split(/\s/)

    split.map.with_index do |word, index|

      next unless word.match(/[a-zA-Z]+?[1-6]/)

      tone = "tone-" + word[-1].to_s

      word_sani = word.gsub(/\*.+?/, "")

      stuff = content_tag :a, class: "sm2_button", :href => "http://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/sound/#{word_sani}.wav", :class => "sm2_button" do
        "Play"
      end

      #bubbleInfo
      stuff += content_tag :span, :class => "trigger" do
        word
      end

      stuff
    end.join("\n").html_safe

  end

end