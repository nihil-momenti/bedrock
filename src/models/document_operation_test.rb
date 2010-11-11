require 'document_operation'

include Rave::Models

client_operation = DocumentOperation.new
server_operation = DocumentOperation.new

client_operation  <<
  DocOp.new(:retain, :length => 10) <<
  DocOp.new(:insert_text, :text => "Hello") <<
  DocOp.new(:retain, :length => 10)
   
server_operation <<
  DocOp.new(:retain, :length => 10) <<
  DocOp.new(:insert_text, :text => " World!") <<
  DocOp.new(:retain, :length => 10)
                 
p "Client operation:"
p client_operation
p "Server operation:"
p server_operation

trans_client_operation, trans_server_operation = DocumentOperation.transform(client_operation, server_operation)

p "Transformed client operation:"
p trans_client_operation
p "Transformed server operation:"
p trans_server_operation