require_relative 'doc_op'

module Bedrock
  class DocumentOperation
    def initialize
      @ops = []
    end
    
    def append(op)
      @ops << op
      return self
    end
    
    def <<(op)
      @ops << op
      return self
    end
    
    def apply(document)
      
    end
    
    def length
      @ops.reduce(0) {|accum, op| accum + op.length}
    end
    
    def transform(other)
      DocumentOperation.transform(self, other)
    end
    
    def [](key)
      return @ops[key]
    end
    
    def inspect
      s = ""
      @ops.each do |op|
        s << "    #{op.inspect}\n"
      end
      return s
    end
    
    def to_json(*a)
      {
        'json_class' => self.class.name,
        'ops'        => @ops
      }.to_json(*a)
    end
    
    class << self
      def transform(client_operation, server_operation)
        client_transform = DocumentOperation.new
        server_transform = DocumentOperation.new
        op1, op2 = client_operation[0], server_operation[0]
        i, j = 0, 0
        while op1 != nil and op2 != nil
          client_op, op1, server_op, op2 = DocOp.transform(op1, op2)
          client_transform << client_op if client_op
          server_transform << server_op if server_op
          op1 = client_operation[i = i.next] unless op1
          op2 = server_operation[j = j.next] unless op2
        end
        return client_transform, server_transform
      end
      
      def json_create(o)
        operation = DocumentOperation.new
        o['ops'].each do |op|
          operation << op
        end
        return operation
      end
    end
  end
end
