describe 'Page' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Page entity' do
    Page.entity_description.name.should == 'Page'
  end

end
