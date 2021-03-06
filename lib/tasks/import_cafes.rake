namespace :db do
  namespace :import do
    desc 'imports cafes to db from Street Cafes csv'
    task cafes: :environment do
      CSVCafeImporter.import_cafes(ENV['IMPORT_PATH'])
      puts "#{StreetCafe.all.length} were imported to street_cafes table"
    end
  end
end
