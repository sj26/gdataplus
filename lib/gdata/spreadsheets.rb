module GData
  class Spreadsheets
    include Enumerable
    
    SPREADSHEETS_LIST_URL = 'https://spreadsheets.google.com/feeds/spreadsheets/private/full'.freeze
    
    # A GData::Client::Spreadsheets service, ready for use
    attr_accessor :service
    # The URL we list spreadsheets from, defaults to SPREADSHEETS_LIST_URL
    attr_accessor :url
    
    def initialize options={}
      options.each do |key, value|
        self.send("#{key}=", value)
      end
      
      @url ||= SPREADSHEETS_LIST_URL
    end
    
    delegate :length, :[], :each, :to => :spreadsheets
    
    def length
      spreadsheets.length
    end
    
    def [] key
      spreadsheets[key]
    end
    
    def each(&b)
      spreadsheets.each(&b)
    end
  
    def reload!
      @feed = @spreadsheets = nil
      self
    end
    
  protected 
    
    def feed
      @feed ||= Nokogiri::XML.parse(service.get(SPREADSHEETS_LIST_URL).body)
    end
    
    def spreadsheets
      @spreadsheets ||= feed.xpath('/xmlns:feed/xmlns:entry').collect do |entry|
        GData::Spreadsheets::Spreadsheet.new :service => service,
          :url => entry.at_xpath('xmlns:content')[:src],
          :author_name => entry.at_xpath('xmlns:author/xmlns:name').text,
          :author_email => entry.at_xpath('xmlns:author/xmlns:email').text
      end
    end
  end
end