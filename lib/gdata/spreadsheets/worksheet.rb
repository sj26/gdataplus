module GData
  class Spreadsheets
    class Worksheet
      include Enumerable
      
      FEED_REL = "http://schemas.google.com/spreadsheets/2006#cellsfeed".freeze
      BATCH_REL = "http://schemas.google.com/g/2005#batch".freeze
      
      attr_accessor :service, :url
      
      def initialize options={}
        options.each do |key, value|
          self.send("#{key}=", value)
        end
      end
      
      def title
        @title ||= entry.at_xpath("/xmlns:entry/xmlns:title").try(:text)
      end
          
      def [] row, col
        changes[[row, col]] || cell_node(row, col).try(:text)
      end
      
      def []= row, col, value
        changes[[row, col]] = value
        value
      end
      
      def changes
        @changes ||= {}
      end
      
      def changed?
        changes.present?
      end
      
      def reload!
        @entry = @feed = @title = @changes = nil
        self
      end
      
      def save
        old_if_match = service.headers["If-Match"]
        service.headers["If-Match"] = "*"
        
        if changed?
          service.post changes_url, changes_xml
          @changes = []
        end
        
        true
        
      ensure
        service.headers["If-Match"] = old_if_match
      end
      
    protected 
      
      def entry_xml
        service.get(url).body
      end
      
      def entry
        @entry ||= Nokogiri::XML.parse(entry_xml)
      end
      
      def feed_url
        entry.at_xpath("/xmlns:entry/xmlns:link[@rel='#{FEED_REL}']")["href"]
      end
      
      def feed_xml
        service.get(feed_url).body
      end
      
      def feed
        @feed ||= Nokogiri::XML.parse feed_xml
      end
      
      def cell_node row, col
        feed / "/xmlns:feed/xmlns:entry/gs:cell[@row='#{row}'][@col='#{col}']"
      end
      
      def changes_url
        feed.xpath("/xmlns:feed/xmlns:link[@rel='#{BATCH_REL}']").first["href"]
      end
      
      def changes_xml
        Nokogiri::XML::Builder.new do |xml|
          xml.feed "xmlns" => "http://www.w3.org/2005/Atom",
              "xmlns:batch" => "http://schemas.google.com/gdata/batch",
              "xmlns:gs" => "http://schemas.google.com/spreadsheets/2006" do
            xml.id_ feed_url
            changes.each do |(row, col), value|
              xml.entry do
                xml["batch"].id_ "R#{row}C#{col}"
                xml["batch"].operation "type" => "update"
                link = cell_node(row, col).xpath("../xmlns:link[@rel='edit']").first["href"]
                xml.id_ link
                xml.link :rel => "edit", :type => "application/atom+xml", :href => link
                xml["gs"].cell :row => row, :col => col, :inputValue => value
              end
            end
          end
        end.to_xml
      end
      
    end
  end
end
