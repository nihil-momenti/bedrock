require_relative '../spec_helper'

require 'bedrock/blip'

module Bedrock
  describe Blip do
    describe '#id' do
      context 'when just constructed' do
        it 'returns the specified id' do
          @blip = Blip.new('an_id')
          @blip.id.should == 'an_id'
        end
      end
    end

    [:contributors, :body, :annotations].each do |attr|
      describe "##{attr}" do
        context 'when just constructed' do
          it 'returns an empty array' do
            @blip = Blip.new('an_id')
            @blip.send(attr).should be_empty
          end
        end
      end
    end

    describe '#[]=' do
      context 'when it is used' do
        it 'sets the value' do
          @blip = Blip.new('an_id')
          @blip[5] = 'something'
          @blip[5].should == 'something'
        end
      end
    end

    describe 'to_xml' do
      context 'when just constructed' do
        it 'returns an empty blip' do
          @blip = Blip.new('an_id')
          @blip.to_xml.should == "<body>\n</body>"
        end
      end

      context 'when contributors added' do
        it 'returns the contributors'
      end

      context 'when body added' do
        it 'returns the added body'
      end

      context 'when contributors and body added' do
        it 'returns the added contributors and body'
      end
    end
  end
  
  describe Line do
    describe '#to_xml' do
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

  describe Element do
    describe '#to_xml' do
      context 'when given no attributes' do
        it 'returns a basic start element' do
          @start_element = Element.new(:start, 'name')
          @start_element.to_xml.should == '<name>'
        end

        it 'returns a basic end element' do
          @end_element = Element.new(:end, 'name')
          @end_element.to_xml.should == '</name>'
        end
      end

      context 'when given attributes' do
        it 'returns a start element with attributes' do
          @start_element = Element.new(:start, 'name', :a1 => 'v1', :a2 => 'v2')
          @start_element.to_xml.should == '<name a1="v1" a2="v2">'
        end

        it 'returns a basic end element' do
          @end_element = Element.new(:end, 'name', :a1 => 'v1', :a2 => 'v2')
          @end_element.to_xml.should == '</name>'
        end
      end
    end

    describe '#update_attributes' do
      before :each do
        @start_element = Element.new(:start, 'name', :a1 => 'v1', :a2 => 'v2')
      end
      context 'when given new value for existing attribute' do
        it 'changes the specified attribute value without touching others' do
          @start_element.update_attributes :a1 => 'v3'
          @start_element.to_xml.should == '<name a1="v3" a2="v2">'
        end
      end

      context 'when given nil for existing attribute' do
        it 'removes the specified attribute without touching others' do
          @start_element.update_attributes :a1 => nil
          @start_element.to_xml.should == '<name a2="v2">'
        end
      end

      context 'when given new value for new attribute' do
        it 'adds the specified attribute without touching others' do
          @start_element.update_attributes :a3 => 'v3'
          @start_element.to_xml.should == '<name a1="v1" a2="v2" a3="v3">'
        end
      end
    end

    describe '#replace_attributes' do
      it 'changes all the attributes' do
        @start_element = Element.new(:start, 'name', :a1 => 'v1', :a2 => 'v2')
        @start_element.replace_attributes :a2 => 'v3'
        @start_element.to_xml.should == '<name a2="v3">'
      end
    end
  end
end
