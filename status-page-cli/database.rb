require 'sequel'

# little wrapper for the sequel
class Database
  def initialize(file = 'default')
    @db = Sequel.connect("sqlite://#{file}")
    migrate
  end

  def migrate
    return if @db.table_exists?(:entries)

    @db.create_table :entries do
      primary_key :id
      String :name, null: false
      String :status, null: false
      DateTime :date, null: false
    end
  end

  def drop
    @db.drop_table(:entries)
    migrate
  end

  def method_missing(*args)
    skip_methods = %i[to_a to_hash to_io to_str to_ary to_int]
    super if skip_methods.include? args[0]

    @db[args[0]] if @db.table_exists?(args[0])
  end

  def respond_to?(method_name, include_private = false)
    @db.table_exists?(method_name) || super
  end
end
