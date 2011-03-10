# GData Plus

Extending GData to provide a nicer, ruby-like interface to certain APIs.

This is currently just a meagre prototype. Beware, this is my first exploration of Nokogiri, although I'm quite seasoned with GData.

## Example

    require 'rubygems'
    require 'gdata'
    require 'gdataplus'

    service = Google::Client::Spreadsheets.new
    service.clientlogin 'me@example.com', 'my-password'
    spreadsheets = service.spreadsheets
    spreadsheet = spreadsheets.first
    worksheet = spreadsheet.first
    worksheet.title
    => "My Fabulous Worksheet"
    worksheet[2, 2]
    => "Cell contents"
    worksheet[2, 1] = "See:"
    worksheet[2, 2] = "New content"
    worksheet[2, 2]
    => "New content"
    worksheet.save
    => true

## Copying

Whatever. See LICENSE.
