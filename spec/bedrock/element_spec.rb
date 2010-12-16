require_relative '../spec_helper'

require 'bedrock/element'

module Bedrock
  describe Element do
    describe '#to_xml' do
      context 'when given no attributes' do
        it 'returns a basic start element' do
          @start_element = Element.new(:start, 'name')
          @start_element.to_xml.should == "\n<name>"
        end

        it 'returns a basic end element' do
          @end_element = Element.new(:end, 'name')
          @end_element.to_xml.should == '</name>'
        end
      end

      context 'when given attributes' do
        it 'returns a start element with attributes' do
          @start_element = Element.new(:start, 'name', :a1 => 'v1', :a2 => 'v2')
          @start_element.to_xml.should == "\n<name a1=\"v1\" a2=\"v2\">"
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
          @start_element.to_xml.should == "\n<name a1=\"v3\" a2=\"v2\">"
        end
      end

      context 'when given nil for existing attribute' do
        it 'removes the specified attribute without touching others' do
          @start_element.update_attributes :a1 => nil
          @start_element.to_xml.should == "\n<name a2=\"v2\">"
        end
      end

      context 'when given new value for new attribute' do
        it 'adds the specified attribute without touching others' do
          @start_element.update_attributes :a3 => 'v3'
          @start_element.to_xml.should == "\n<name a1=\"v1\" a2=\"v2\" a3=\"v3\">"
        end
      end
    end

    describe '#replace_attributes' do
      it 'changes all the attributes' do
        @start_element = Element.new(:start, 'name', :a1 => 'v1', :a2 => 'v2')
        @start_element.replace_attributes :a2 => 'v3'
        @start_element.to_xml.should == "\n<name a2=\"v3\">"
      end
    end
  end
end
