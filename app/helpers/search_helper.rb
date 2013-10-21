module SearchHelper
  def build_jyutping(full_word)

    return unless full_word.jyutping.present? 

    split = full_word.jyutping.split(/\s/)

    split.map.with_index do |word, index|

      next unless word.match(/[a-zA-Z]+?[1-6]/)

      tone = "tone-" + word[-1].to_s

      word_sani = word.gsub(/\*.+?/, "")

      stuff = content_tag :a, :href => "http://humanum.arts.cuhk.edu.hk/Lexis/lexi-can/sound/#{word_sani}.wav", :class => "sm2_button" do
        "Play"
      end

      stuff += content_tag :span, :class => "bubbleInfo" do
        output = content_tag :a, :href => "#", :class => "trigger" do
          word
        end

        output += content_tag :div, :class => "popup" do
          out = content_tag :h1 do
            out1 = content_tag :span, :class => "large_chinese_chars" do
              full_word.chars_trad[index]
            end 

            out1 += " - " + word
          end

          out
        end

        output
      end

      stuff
    end.join("\n").html_safe

  end

end


#             .bubbleInfo
#               %a.trigger{:href => "#"}
#                 =r.jyutping
#               .popup
#                 %h1
#                   =r.jyutping
#                 .image
#                   =image_tag "/images/cantonese_tones.png"