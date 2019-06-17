require 'json'
require_relative 'base_storage'
# implementation for json storage
class Json < BaseStorage
  def insert(entry)
    create unless File.file?(@filename)
    array = JSON.parse(File.read(@filename))
    File.write(@filename, array.push(entry).to_json)
  end

  def create
    File.write(@filename, [].to_json)
  end

  def drop
    create
  end

  def where(params = {})
    create unless File.file?(@filename)
    array = JSON.parse(File.read(@filename))
    array.map! { |hash| Hash[hash.map { |k, v| [k.to_sym, v] }] }
    array.select! { |value| value[:name] == params[:name] } if params[:name]
    array.select! { |value| value[:status] == params[:status] } if params[:status]
    array
  end

  def all
    where
  end

  private

  def create
    File.write(@filename, [].to_json)
  end
end
