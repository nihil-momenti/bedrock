require_relative 'doc_op'

module Bedrock
  class DocumentOperation
    attr_reader :ops

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

    def to_json
      { "1" => @ops.map(&:to_json) }.to_json
    end

    def compress
      ops = @ops.dup
      operation = DocumentOperation.new
      op1, op2 = ops.shift 2
      while op2 != nil
        if op1.type == op2.type and op1.can_combine?
          op1 = op1.combine(op2)
          op2 = ops.shift
        else
          operation << op1
          op1 = op2
          op2 = ops.shift
        end
      end
      operation << op1
      return operation
    end

    def == other
      DocumentOperation === other and @ops == other.ops
    end
    
    def self.transform(client_operation, server_operation)
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
      return client_transform.compress, server_transform.compress
    end

    def self.from_json(json)
      operation = new
      json['1'].map{ |j| DocOp.from_json(j) }.each do |op|
        operation << op
      end
      return operation
    end
  end
end
