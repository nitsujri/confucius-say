module SearchHelper
  def build_jyutping(full_word)

    return unless full_word.jyutping.present? 

    split = full_word.jyutping.split(/\s/)

    split.map.with_index do |word, index|

      tone = "tone-" + word[-1].to_s

      content_tag :span, :class => "bubbleInfo" do
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

          #out1 gets used again
          out += content_tag :div, :class => "image #{tone}" do
            out1 = tag :img, :src => "/images/6-tones-in-cantonese.png"

            out1 += content_tag :div, "", :class => "screen-l"
            out1 += content_tag :div, "", :class => "screen-r"
            out1
          end
          out
        end

        output
      end
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