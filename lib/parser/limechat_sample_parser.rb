class ChistApp::Limechat
  class Sample

    def self.parse(log)
      #scan for participants
      participants = log.scan(/\d{2}:\d{2}\s\(([^)]+)\)/).uniq.collect! { |scan| scan.first }
      #map usernames
      classes = Hash.new
      participants.each_with_index { |username, key| classes[username] = "<span class=\"username_#{key}\">#{username}</span>"}
      #identify links
      log.gsub! /(https?:\/\/[^\s\n]*)/, '<a href="\1" target="_blank">\1</a>'
      #identify messages
      log.gsub! /(\d{2}:\d{2}\s\([^)]+\))(.*)/, '\1<span class="message">\2</span>'
      #apply class to usernames
      classes.each do |k,v|
        log.gsub! /(\()#{Regexp.escape(k)}(\))/, '<span class="open-close">\1</span>' + v + '<span class="open-close">\2</span>'
      end
      #add outter div and identify channel info lines
      output = ""
      log.split(/\n\r?/).each do |line|
        unless line =~ /\"username_\d\"/
          output += "<div class=\"line\">" + line.gsub(/^(.+)$/, '<span class="channel-info">\1</span>') + "</div>\r\n"
        else
          output += "<div class=\"line\">" + line + "</div>\r\n"
        end
      end

      output
    end
  end
end
