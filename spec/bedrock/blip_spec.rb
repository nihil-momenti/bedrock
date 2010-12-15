require_relative '../spec_helper'

require 'bedrock/blip'

module Bedrock
  describe Blip do
    before :each do
      @blip = Blip.new('an_id')
    end

    describe '#id' do
      context 'when just constructed' do
        it 'returns the specified id' do
          @blip.id.should == 'an_id'
        end
      end
    end

    [:contributors, :body, :annotations].each do |attr|
      describe "##{attr}" do
        context 'when just constructed' do
          it 'returns an empty array' do
            @blip.send(attr).should be_empty
          end
        end
      end
    end

    describe '#[]=' do
      context 'when it is given a single character' do
        before :each do
          @blip[5] = 's'
        end

        it 'sets the value' do
          @blip[5].should == 's'
        end
      end
    end

    describe '#to_xml' do
      context 'when just constructed' do
        it 'returns an empty blip' do
          @blip.to_xml.should == "<body>\n</body>"
        end
      end

      context 'when contributors added' do
        it 'returns the contributors'
      end

      context 'when body added' do
        before :each do
          @blip[0] = Line.new :t => :h1
          @blip[1,10] = 'first line'.chars.to_a
          @blip[11] = Line.new
          @blip[12,11] = 'second line'.chars.to_a
        end

        it 'returns the added body' do
          @blip.to_xml.should == "<body>\n<line t=\"h1\"></line>first line\n<line></line>second line\n</body>"
        end
      end

      context 'when contributors and body added' do
        it 'returns the added contributors and body'
      end
    end

    describe '#apply' do
      context 'when passed in a doc_op' do
        before :each do
          @doc_op = mock('doc_op')
        end

        it 'calls the doc_ops #apply method' do
          @doc_op.should_receive(:apply)
          @blip.apply(@doc_op)
        end
      end
    end
  end
  
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
