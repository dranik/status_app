require_relative '../../storage/json'

RSpec.describe 'Database' do
  before(:each) do
    @db = Json.new 'testfile'
  end

  describe 'insert' do
    it 'inserts data' do
      @db.insert(name: 'Name', status: ['up', 'down'].sample, date: Time.now)
      expect(@db.all.count).to eq 1
    end
  end

  describe 'drop' do
    it 'wipes data' do
      @db.insert(name: 'Name', status: ['up', 'down'].sample, date: Time.now)
      @db.drop
      expect(@db.all.count).to eq 0
    end
  end

  describe 'all' do
    it 'returns all the data' do
      time = Time.new(0)
      @db.drop
      entries = [
        { name: 'Name', status: 'up', date: time },
        { name: 'Name2', status: 'up', date: time },
        { name: 'Name3', status: 'up', date: time }
      ]
      entries.each { |entry| @db.insert(entry) }
      expect(@db.all).to eq [
        { name: 'Name', status: 'up', date: time.to_s },
        { name: 'Name2', status: 'up', date: time.to_s },
        { name: 'Name3', status: 'up', date: time.to_s }
      ]
    end
  end

  describe 'where' do
    it 'returns requested data' do
      time = Time.new(0)
      @db.drop
      entries = [
        { name: 'Name', status: 'up', date: time },
        { name: 'Name2', status: 'down', date: time },
        { name: 'Name3', status: 'up', date: time }
      ]
      entries.each { |entry| @db.insert(entry) }

      expect(@db.where({})).to eq [
        { name: 'Name', status: 'up', date: time.to_s },
        { name: 'Name2', status: 'down', date: time.to_s },
        { name: 'Name3', status: 'up', date: time.to_s }
      ]

      expect(@db.where(status: 'up')).to eq [
        { name: 'Name', status: 'up', date: time.to_s },
        { name: 'Name3', status: 'up', date: time.to_s }
      ]

      expect(@db.where(status: 'down')).to eq [
        { name: 'Name2', status: 'down', date: time.to_s }
      ]

      expect( @db.where(name: 'Name')).to eq [
        { name: 'Name', status: 'up', date: time.to_s }
      ]
      
      expect(@db.where(name: 'Name', status: 'down')).to eq []
    end
  end

  describe 'filename' do
    it 'returns file name' do
      expect(@db.filename).to eq 'testfile'
    end
  end

  after(:all) do
    File.delete 'testfile'
  end
end
