module HomeHelper
  def build_jyutping(words)
    split = words.split(/\s/)
    
    split.map do |word|
      content_tag :span, :class => "bubbleInfo" do
        output = content_tag :a, :href => "#", :class => "trigger" do
          word
        end

        output += content_tag :div, :class => "popup" do
          out = content_tag :h1 do
            word
          end

          out += content_tag :div, :class => "image" do
            tag :img, :src => "/images/cantonese_tones.png"
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