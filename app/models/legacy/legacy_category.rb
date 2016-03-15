class LegacyCategory < ActiveRecord::Base
  establish_connection :legacy_db
  self.table_name = 'categories'
end