class OneOffs
  class GetStrokeImgs

    def start
      start_url = "/wiki/Category:Bw.png_stroke_order_images"
      visit_category(start_url)
    end

    def visit_category(url)
      #begin with start url

      response    = visit_url("http://commons.wikimedia.org" + url)
      parsed_html = Nokogiri::HTML(response)
      
      parsed_html.css(".gallerybox").each do |gbox|
        visit_character(gbox.at_css(".gallerytext").at_css("a")[:href])
      end

      #recursion
      next_url = parsed_html.search("[text()*='next ']").first

      visit_category next_url[:href] if next_url.present?

    end

    def visit_url(url)
      attempts = 0
      begin
        response = HTTParty.get(url, :headers => {"User-Agent" => OneOffs::APPLICATION_NAME})
      rescue => e
        ap "!!!! ERROR: #{e.messages}"
        attempts += 1
        retry unless attempts > 6
      end

      response
    end

    def visit_character(url)

      response    = visit_url("http://commons.wikimedia.org" + url)
      parsed_html = Nokogiri::HTML(response)

      img_url = parsed_html.at_css(".fullMedia").at_css("a")

      return unless img_url.present?

      response = visit_url("http:" + img_url[:href])

      "http://upload.wikimedia.org/wikipedia/commons/e/ed/%E4%BB%80-bw.png"
      file_name = CGI::unescape(img_url[:href].split("/").last)
      Magick::ImageList.new.from_blob(response.body).write(File.join(Rails.root, "tmp", "stroke_images", file_name))
      ap ">>>> Got: #{file_name}!"
    end

    class << self
      def go
        # OneOffs::GetStrokeImgs.go
        OneOffs::GetStrokeImgs.new.start
      end
    end
  end
end