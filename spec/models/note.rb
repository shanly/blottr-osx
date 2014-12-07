describe 'Note' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Note entity' do
    Note.entity_description.name.should == 'Note'
  end
end
