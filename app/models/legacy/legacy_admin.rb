class LegacyAdmin < ActiveRecord::Base
  establish_connection :legacy_db
  self.table_name = 'admins'
end