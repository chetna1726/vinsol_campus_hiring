class LegacyAnswer < ActiveRecord::Base
  establish_connection :legacy_db
  self.table_name = 'answers'
end