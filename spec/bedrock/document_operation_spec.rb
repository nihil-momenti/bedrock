require_relative '../spec_helper'

require 'bedrock/document_operation'

require 'json'

include Bedrock

describe DocumentOperation do
  context 'WIAB test cases' do
    test_cases = []
    File.open(File.join(File.dirname(__FILE__), 'transformtests.json')) do |file|
      file.lines.each_slice(4) do |op1, op2, result, client|
        begin
          test_cases << {
            op1:    DocumentOperation.from_json(JSON.parse(op1)),
            op2:    DocumentOperation.from_json(JSON.parse(op2)),
            result: DocumentOperation.from_json(JSON.parse(result)),
            client: client == "true\n"
          }
        rescue NotImplementedError
          test_cases << nil
        end
      end
    end

    num = 0
    test_cases.each do |test_case|
      if test_case == nil
        it "test #{num += 1}"
      else
        it "test #{num += 1}" do
          if test_case[:client]
            result = test_case[:op1].transform(test_case[:op2])[1]
          else
            result = test_case[:op2].transform(test_case[:op1])[0]
          end
          result.should == test_case[:result]
        end
      end
    end
  end
end
