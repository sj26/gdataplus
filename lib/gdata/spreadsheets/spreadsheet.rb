module GData
  class Spreadsheets
    class Spreadsheet
      include Enumerable

      attr_accessor :service, :url
      
      def initialize options={}
        @author_name = options.delete :author_name
        @author_email = options.delete :author_email
        
        options.each do |key, value|
          self.send("#{key}=", value)
        end
      end
      
      def author_name
        @author_name ||= feed.at_xpath('/xmlns:feed/xmlns:author/xmlns:name')
      end
      
      def author_email
        @author_email ||= feed.at_xpath('/xmlns:feed/xmlns:author/xmlns:email')
      end
      
      def worksheets
        @worksheets ||= begin
          feed.xpath('/xmlns:feed/xmlns:entry').collect do |entry|
            GData::Spreadsheets::Worksheet.new :service => service,
              :url => entry.at_xpath('xmlns:link[@rel="self"]')[:href]
          end
        end
      end
      
      delegate :[], :length, :each, :to => :worksheets
      
      def reload!
        @feed = @worksheets = @author_name = @author_email = nil
        self
      end
      
    protected 
      
      def feed
        @feed ||= Nokogiri::XML.parse(service.get(url).body)
      end
    end
  end
end
