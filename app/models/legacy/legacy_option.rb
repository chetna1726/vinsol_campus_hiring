class LegacyOption < ActiveRecord::Base
  establish_connection :legacy_db
  self.table_name = 'options'
end