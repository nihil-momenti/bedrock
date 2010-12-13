require_relative '../src/bedrock/document_operation.rb'
require 'rubygems'
require 'json'

include Bedrock

ops = JSON.parse(open(File.dirname(__FILE__) + '/' + 'document_operation_test_cases.json').read)

ops.each do |pair|
  p "Client operation:"
  p pair[0]
  p "Server operation:"
  p pair[1]

  trans_pair_0, trans_pair_1 = DocumentOperation.transform(pair[0], pair[1])

  p "Transformed client operation:"
  p trans_pair_0
  p "Transformed server operation:"
  p trans_pair_1
end
