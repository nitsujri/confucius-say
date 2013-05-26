module HomeHelper
  def build_jyutping(words)
    split = words.split(/\s/)

    split.map do |word|

      tone = "tone-" + word[-1]

      content_tag :span, :class => "bubbleInfo" do
        output = content_tag :a, :href => "#", :class => "trigger" do
          word
        end

        output += content_tag :div, :class => "popup" do
          out = content_tag :h1 do
            word
          end

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


# .bubbleInfo
#               %a.trigger{:href => "#"}
#                 =r.jyutping
#               .popup
#                 %h1
#                   =r.jyutping
#                 .image
#                   =image_tag "/images/cantonese_tones.png"