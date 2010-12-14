require_relative '../spec_helper'

require 'bedrock/blip'

module Bedrock
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
  
  describe Line do
    describe '#initialize' do
      context 'when given no options' do
        it 'should create an empty element' do
          @line = Line.new
          @line.should be
        end
      end
  
      context 'when given options' do
        it 'should create a non-empty element' do
          @line = Line.new(:t => 'h1')
          @line.should be
        end
      end
    end
  
    describe '#to_s' do
      context 'when given no options' do
        it 'returns an empty element' do
          @line = Line.new
          @line.to_xml.should == '<line></line>'
        end
      end
  
      context 'when given a line type' do
        it 'returns an element with that line type' do
          @line = Line.new(:t => 'h1')
          @line.to_xml.should == '<line t="h1"></line>'
        end
      end
    end
  end
end
