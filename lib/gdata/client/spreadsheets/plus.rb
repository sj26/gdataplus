module GData
  module Client
    class Spreadsheets
      def spreadsheets
        @spreadsheets ||= GData::Spreadsheets.new(:service => self)
      end
    end
  end
end