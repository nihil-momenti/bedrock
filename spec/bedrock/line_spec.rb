require_relative '../spec_helper'

require 'bedrock/line'

module Bedrock
  describe Line do
    describe '#to_xml' do
      context 'when given no options' do
        it 'returns an empty element' do
          @line = Line.new
          @line.to_xml.should == "\n<line></line>"
        end
      end
  
      context 'when given a line type' do
        it 'returns an element with that line type' do
          @line = Line.new(:t => 'h1')
          @line.to_xml.should == "\n<line t=\"h1\"></line>"
        end
      end
    end
  end
end
