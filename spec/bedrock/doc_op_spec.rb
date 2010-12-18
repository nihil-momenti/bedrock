require_relative '../spec_helper'

require 'bedrock/doc_op'

module Bedrock
  describe DocOp do
    before :each do
      @offset = 10
    end

    context 'when :retain operation' do
      before :each do
        @length = 20
        @doc_op = DocOp.new(:retain, :length => @length)
      end

      describe '#initialize' do
        it 'sets the length to the given argument' do
          @doc_op.length.should == @length
        end
      end

      describe '#apply' do
        it 'returns the current offset + the retain length' do
          @doc_op.apply(nil, @offset).should == @offset + @length
        end
      end
    end

    context 'when :insert_text operation' do
      before :each do
        @text = 'a test phrase'
        @doc_op = DocOp.new(:insert_text, :text => @text)
      end

      describe '#initialize' do
        it 'sets the text to the given argument' do
          @doc_op.text.should == @text
        end

        it 'freezes the text' do
          @doc_op.text.should be_frozen
        end

        it 'sets the length to the length of the given text' do
          @doc_op.length.should == @text.length
        end
      end

      describe '#apply' do
        it 'inserts the text at the offset and returns the current offset + the length of the text' do
          document = mock('document')
          document.should_receive(:[]=).with(@offset, 0, @text.chars.to_a)
          @doc_op.apply(document, @offset).should == @offset + @text.length
        end
      end
    end

    context 'when :delete_text operation' do
      before :each do
        @text = 'a test phrase'
        @doc_op = DocOp.new(:delete_text, :text => @text)
      end

      describe '#initialize' do
        it 'sets the text to the given argument' do
          @doc_op.text.should == @text
        end

        it 'freezes the text' do
          @doc_op.text.should be_frozen
        end

        it 'sets the length to the length of the given text' do
          @doc_op.length.should == @text.length
        end
      end

      describe '#apply' do
        it 'replaces the text at the offset and returns the offset' do
          document = mock('document')
          document.should_receive(:[]=).with(@offset, @text.length, [])
          @doc_op.apply(document, @offset).should == @offset
        end
      end
    end

    context 'when :insert_element_start operation' do
      before :each do
        @name = 'an_element'
        @attributes = {:a1 => 'v1', :a2 => 'v2'}
        @doc_op = DocOp.new(:insert_element_start, :name => @name, :attributes => @attributes)
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
        end
      end

      describe '#apply' do
        it 'inserts the element at the specified offset and returns offset + 1' do
          document = mock('document')
          document.should_receive(:[]=).with(@offset, 0, [an_instance_of(Element)])
          @doc_op.apply(document, @offset).should == [@offset + 1, @name]
        end
      end
    end

    context 'when :insert_element_end operation' do
      before :each do
        @doc_op = DocOp.new(:insert_element_end)
        @name = 'element_name'
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
        end
      end

      describe '#apply' do
        it 'inserts the element at the specified offset and returns offset + 1' do
          document = mock('document')
          document.should_receive(:[]=).with(@offset, 0, [an_instance_of(Element)])
          @doc_op.apply(document, @offset, @name).should == @offset + 1
        end
      end
    end

    context 'when :delete_element_start operation' do
      before :each do
        @doc_op = DocOp.new(:delete_element_start)
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
        end
      end

      describe '#apply' do
        it 'deletes the element at the specified offset and returns the offset' do
          document = mock('document')
          document.should_receive(:[]=).with(@offset, 1, [])
          @doc_op.apply(document, @offset).should == @offset
        end
      end
    end

    context 'when :delete_element_end operation' do
      before :each do
        @doc_op = DocOp.new(:delete_element_end)
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
        end
      end

      describe '#apply' do
        it 'deletes the element at the specified offset and returns the offset' do
          document = mock('document')
          document.should_receive(:[]=).with(@offset, 1, [])
          @doc_op.apply(document, @offset).should == @offset
        end
      end
    end

    context 'when :replace_attributes operation' do
      before :each do
        @attributes = {:a1 => 'v1', :a2 => 'v2'}
        @doc_op = DocOp.new(:replace_attributes, :attributes => @attributes)
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
        end
      end

      describe '#apply' do
        it 'replaces the attributes on the element at the specified offset and returns the offset + 1' do
          element = mock('element')
          element.should_receive(:replace_attributes).with(@attributes)
          document = mock('document')
          document.should_receive(:[]).with(@offset).and_return(element)
          @doc_op.apply(document, @offset).should == @offset + 1
        end
      end
    end

    context 'when :update_attributes operation' do
      before :each do
        @attributes = {:a1 => 'v1', :a2 => 'v2'}
        @doc_op = DocOp.new(:update_attributes, :attributes => @attributes)
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
        end
      end

      describe '#apply' do
        it 'updates the attributes on the element at the specified offset and returns the offset + 1' do
          element = mock('element')
          element.should_receive(:update_attributes).with(@attributes)
          document = mock('document')
          document.should_receive(:[]).with(@offset).and_return(element)
          @doc_op.apply(document, @offset).should == @offset + 1
        end
      end
    end

    context 'when :annotation_boundary operation' do
      describe '#initialize' do
        it 'raises a NotImplementedError' do
          expect { DocOp.new(:annotation_boundary) }.to raise_error NotImplementedError
        end
      end
    end

    context 'when invalid operation' do
      describe '#initialize' do
        it 'raises a ArgumentError' do
          expect { DocOp.new(:blahblah, :something => 'hellloooo') }.to raise_error ArgumentError
        end
      end
    end

    context 'when any operation' do
      before :each do
        @doc_op_1 = DocOp.new(:retain, :length => 1)
        @doc_op_2 = DocOp.new(:retain, :length => 2)
      end

      describe '#transform' do
        it 'calls DocOp.transform' do
          DocOp.should_receive(:transform).with(@doc_op_1, @doc_op_2).and_return(:return_value)
          @doc_op_1.transform(@doc_op_2).should == :return_value
        end
      end
    end

    describe '.transform' do
      before :each do
        @doc_op_1 = DocOp.new(:retain, :length => 1)
        @doc_op_2 = DocOp.new(:retain, :length => 2)
      end

      it 'calls DocOpTransformer.transform' do
        DocOpTransformer.should_receive(:transform).with(@doc_op_1, @doc_op_2).and_return(:return_value)
        DocOp.transform(@doc_op_1, @doc_op_2).should == :return_value
      end
    end
  end
end
