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

  def insert(entry)
    @db[:entries].insert(entry)
  end

  def drop
    @db.drop_table(:entries)
    migrate
  end

  def where(params)
    @db[:entries].where(params)
  end

  def all
    @db[:entries].all
  end

  def method_missing(*args)
    return @db[args[0]] if @db.table_exists?(args[0])

    super
  end

  def respond_to_missing?(method_name, include_private = false)
    @db.table_exists?(method_name) || super
  end
end
