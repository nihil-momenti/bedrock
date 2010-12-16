require_relative '../spec_helper'

require 'bedrock/blip'
require 'bedrock/contributor'
require 'bedrock/line'
require 'bedrock/element'

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
        before :each do
          @blip.contributors << Contributor.new('me@test.com')
        end

        it 'returns the contributors' do
          @blip.to_xml.should == "<contributor name=\"me@test.com\"></contributor>\n<body>\n</body>"
        end
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
        before :each do
          @blip.contributors << Contributor.new('me@test.com')
          @blip[0] = Line.new :t => :h1
          @blip[1,10] = 'first line'.chars.to_a
          @blip[11] = Line.new
          @blip[12,11] = 'second line'.chars.to_a
        end

        it 'returns the added contributors and body' do
          @blip.to_xml.should == "<contributor name=\"me@test.com\"></contributor>\n<body>\n<line t=\"h1\"></line>first line\n<line></line>second line\n</body>"
        end
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
 end
