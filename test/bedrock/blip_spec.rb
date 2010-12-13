require 'bedrock/blip'

include Bedrock

describe Blip do
  describe '#initialize' do
    context 'when given valid id' do
      before :all do
        @valid_id = 'valid_id'
        @blip = Blip.new(@valid_id)
      end

      it 'creates a new blip' do
        @blip.should be
      end

      it 'sets the id to the given id' do
        @blip.id.should be @valid_id
      end

      [:contributors, :body, :annotations].each do |array|
        it "initializes the #{array} array" do
          @blip.send(array).should be_empty
        end
      end
    end
  end
end
