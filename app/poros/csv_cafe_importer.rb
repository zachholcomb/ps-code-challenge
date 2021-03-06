class CSVCafeImporter
  class << self
    def import_cafes(file)
      reset_models
      import_file(file)
    end

    private

    def import_file(file)
      CSV.foreach(
        file, 
        headers: true,
        header_converters: :symbol) do  |row|
          StreetCafe.create(
            name: row[:cafrestaurant_name],
            street_address: row[:street_addres],
            post_code: row[:post_code],
            number_of_chairs: row[:number_of_chairs],
            notes: row[:nil]
          )
      end
    end

    def reset_models
      StreetCafe.destroy_all
      reset_pk_sequence
    end

    def reset_pk_sequence
      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
    end
  end
end
