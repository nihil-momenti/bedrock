require_relative '../spec_helper'

require 'bedrock/contributor'

module Bedrock
  describe Contributor do
    describe '#to_xml' do
      it 'returns an element with name set' do
        @contributor = Contributor.new('me@test.com')
        @contributor.to_xml.should == "<contributor name=\"me@test.com\"></contributor>\n"
      end
    end
  end
end
