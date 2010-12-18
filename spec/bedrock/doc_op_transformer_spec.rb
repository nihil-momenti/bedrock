require_relative '../spec_helper'

require 'bedrock/doc_op_transformer'

module Bedrock
  describe DocOpTransformer do
    describe '.transform' do
      context 'retain client_op' do
        before :each do
          @client_length = 10
          @client_op = DocOp.new(:retain, :length => @client_length)
        end

        context 'retain server_op' do
          describe 'when same length' do
            before :each do
              @server_length = @client_length
              @server_op = DocOp.new(:retain, :length => @server_length)
            end

            it 'returns the two ops' do
              DocOpTransformer::transform(@client_op, @server_op).should == [@client_op, nil, @server_op, nil]
            end
          end
        end
      end
    end
  end
end
