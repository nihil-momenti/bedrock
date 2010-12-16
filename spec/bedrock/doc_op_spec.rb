require_relative '../spec_helper'

require 'bedrock/doc_op'

module Bedrock
  describe DocOp do
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
    end

    context 'when :insert_element_end operation' do
      before :each do
        @doc_op = DocOp.new(:insert_element_end)
      end

      describe '#initialize' do
        it 'sets the length to 1' do
          @doc_op.length.should == 1
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
