require 'rails_helper'

RSpec.describe CSVExporter do
  before(:each) do
    cafe1 = StreetCafe.create!(name: 'All Bar Most Chairs', street_address: 'Unit D Electric Press, 4 Millenium Square', post_code: 'LS1 5BN', number_of_chairs: 140)
    cafe2 = StreetCafe.create!(name: 'Caffé Nero (Albion Place side)', street_address: '19 Albion Place', post_code: 'LS1 6JS', number_of_chairs: 16)
    cafe3 = StreetCafe.create!(name: 'BHS', street_address: '49 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 6)
    cafe4 = StreetCafe.create!(name: 'Hotel Chocolat', street_address: '55 Boar Lane', post_code: 'LS1 5EL', number_of_chairs: 12)
    cafe5 = StreetCafe.create!(name: 'Cattle Grid', street_address: "Waterloo House, Assembly Street", post_code: 'LS2 7DB', number_of_chairs: 20)
    cafe6 = StreetCafe.create!(name: 'Chilli White', street_address: 'Assembly Street', post_code: 'LS2 7DA', number_of_chairs: 51)
    cafe7 = StreetCafe.create!(name: 'Safran', street_address: '81 Kirkgate', post_code: 'LS2 7DJ', number_of_chairs: 6)
    cafe8 = StreetCafe.create!(name: 'Sandinista', street_address: '5 Cross Belgrave Street', post_code: 'LS2 8JP', number_of_chairs: 18)
    cafe9 = StreetCafe.create!(name: 'Tiger Tiger', street_address: '117 Albion St', post_code: 'LS2 8DY', number_of_chairs: 118)
    cafe10 = StreetCafe.create!(name: 'The Wrens Hotel', street_address: '61A New Briggate', post_code: 'LS2 8DY', number_of_chairs: 20)
    cafe11 = StreetCafe.create!(name: 'The Adelphi', street_address: '3 - 5 Hunslet Road', post_code: 'LS10 1JQ', number_of_chairs: 35)
    cafes = StreetCafe.all

    cafes.each do |cafe|
      CafeCategorizer.categorize(cafe)
    end
  end

  it 'export returns the csv data to write' do
    exporter = CSVExporter.new(StreetCafe.cafes_by_category('%small'))
    csv_data = exporter.export_to_csv

    expected_headers = [
      'Café/Restaurant Name',
      'Street Address',
      'Post Code', 
      'Number of Chairs',
      'Category',
      'Notes'
    ]
    rows = csv_data.split("\n")
    
    rows.each_with_index do |row, index|
      if index == 0
        headers = row.split(',')
        headers.each do |actual_header|
          expect(expected_headers).to include(actual_header)
        end
      else
        actual_row = rows[1].split(',')
        cafe = StreetCafe.find_by(name: actual_row[0])
        expected_data = [
          cafe.name,
          cafe.street_address,
          cafe.post_code,
          cafe.category,
          cafe.number_of_chairs.to_s
        ]
        actual_row.each do |data|
          expect(expected_data).to include(data)
        end
      end
    end
  end
end