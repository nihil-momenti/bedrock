require_relative 'doc_op'

module Bedrock
  module DocOpTransformer
    class << self
      def transform(client_op, server_op)
          eval <<-STR
            return transform_#{client_op.type}(client_op, server_op)
          STR
      end
      
      
      private
      
      def transform_retain(client_op, server_op)
        case server_op.type
        when :retain
          if client_op.length > server_op.length
            return server_op,
                   DocOp.new(:retain, :length => client_op.length - server_op.length),
                   server_op,
                   nil
          elsif server_op.length > client_op.length
            return client_op,
                   nil,
                   client_op,
                   DocOp.new(:retain, :length => server_op.length - client_op.length)
          else
            return client_op,
                   nil,
                   server_op,
                   nil
          end
        
        when :insert_text, :insert_element_start, :insert_element_end
          return server_op,
                 client_op,
                 DocOp.new(:retain, :length => server_op.length),
                 nil
        
        when :delete_text
          if client_op.length > server_op.length
            return server_op,
                   DocOp.new(:retain, :length => client_op.length - server_op.length),
                   nil,
                   nil
          elsif server_op.length > client_op.length
            return DocOp.new(:delete_text, :text => server_op.text[0...client_op.length]),
                   nil,
                   nil,
                   DocOp.new(:delete_text, :text => server_op.text[client_op.length...server_op.length])
          else
            return server_op,
                   nil,
                   nil,
                   nil
          end
        
        when :delete_element_start, :delete_element_end
          if client_op.length > 1
            return server_op,
                   DocOp.new(:retain, :length => client_op.length - 1),
                   nil,
                   nil
          else
            return server_op,
                   nil,
                   nil,
                   nil
          end
        
        when :replace_attributes, :update_attributes
          if client_op.length > 1
            return server_op,
                   DocOp.new(:retain, :length => client_op.length - 1),
                   DocOp.new(:retain, :length => 1),
                   nil
          else
            return server_op,
                   nil,
                   DocOp.new(:retain, :length => 1),
                   nil
          end
        
        else
          raise NotImplementedError
        end
      end
      
      
      def transform_insert_text(client_op, server_op)
        case server_op.type
        when :retain, :insert_text, :insert_element_start, :insert_element_end,
             :delete_text, :delete_element_start, :delete_element_end,
             :replace_attributes, :update_attributes
          return DocOp.new(:retain, length: client_op.length),
                 nil,
                 client_op,
                 server_op
        else
          raise NotImplementedError
        end
      end
      
      
      def transform_insert_element_start(client_op, server_op)
        case server_op.type
        when :retain, :insert_text, :insert_element_start, :insert_element_end,
             :delete_text, :delete_element_start, :delete_element_end,
             :replace_attributes, :update_attributes
          return DocOp.new(:retain, :length => 1),
                 nil,
                 client_op,
                 server_op
        else
          raise NotImplementedError
        end
      end
      
      
      def transform_insert_element_end(client_op, server_op)
        case server_op.type
        when :retain, :insert_text, :insert_element_start, :insert_element_end,
             :delete_text, :delete_element_start, :delete_element_end,
             :replace_attributes, :update_attributes
          return DocOp.new(:retain, :length => 1),
                 nil,
                 client_op,
                 server_op
        else
          raise NotImplementedError
        end
      end
      
      
      def transform_delete_text(client_op, server_op)
        case server_op.type
        when :retain
          if client_op.length > server_op.length
            return nil,
                   DocOp.new(:delete_text, :text => client_op.text[server_op.length...client_op.length]),
                   DocOp.new(:delete_text, :text => client_op.text[0...server_op.length]),
                   nil
          elsif server_op.length > client_op.length
            return nil,
                   nil,
                   client_op,
                   DocOp.new(:retain, :length => server_op.length - client_op.length)
          else
            return nil,
                   nil,
                   client_op,
                   nil
          end
        when :insert_text, :insert_element_start, :insert_element_end
          return server_op,
                 client_op,
                 DocOp.new(:retain, :length => server_op.length),
                 nil
        when :delete_text
          if client_op.length > server_op.length
            return nil,
                   DocOp.new(:delete_text, :text => client_op.text[server_op.length...client_op.length]),
                   nil,
                   nil
          elsif server_op.length > client_op.length
            return nil,
                   nil,
                   nil,
                   DocOp.new(:delete_text, :text => server_op.text[client_op.length...server_op.length])
          else
            return nil,
                   nil,
                   nil,
                   nil
          end
        else
          raise NotImplementedError
        end
      end
      
      def transform_delete_element_start(client_op, server_op)
        case server_op.type
        when :retain
          if server_op.length > 1
            return nil,
                   nil,
                   client_op,
                   DocOp.new(:retain, :length => server_op.length - 1)
          else
            return nil,
                   nil,
                   client_op,
                   nil
          end
        when :insert_text, :insert_element_start, :insert_element_end
          return server_op,
                 client_op,
                 DocOp.new(:retain, :length => server_op.length),
                 nil
        when :delete_element_start
          return nil,
                 nil,
                 nil,
                 nil
        when :replace_attributes, :update_attributes
          return nil,
                 nil,
                 client_op
                 nil
        end
      end
      
      def transform_delete_element_end(client_op, server_op)
        case server_op.type
        when :retain
          if server_op.length > 1
            return nil,
                   nil,
                   client_op,
                   DocOp.new(:retain, :length => server_op.length - 1)
          else
            return nil,
                   nil,
                   client_op,
                   nil
          end
        when :insert_text, :insert_element_start, :insert_element_end
          return server_op,
                 client_op,
                 DocOp.new(:retain, :length => server_op.length),
                 nil
        when :delete_element_end
          return nil,
                 nil,
                 nil,
                 nil
        end
      end
      
      def transform_replace_attributes(client_op, server_op)
        case server_op.type
        when :retain
          if server_op.length > 1
            return DocOp.new(:retain, :length => 1),
                   nil,
                   client_op,
                   DocOp.new(:retain, :length => server_op.length - 1)
          else
            return DocOp.new(:retain, :length => 1),
                   nil,
                   client_op,
                   nil
          end
        when :delete_element_start
          return server_op,
                 nil,
                 nil,
                 nil
        when :replace_attributes
          return DocOp.new(:retain, :length => 1),
                 nil,
                 client_op,
                 nil
        when :update_attributes
          return DocOp.new(:retain, :length => 1),
                 nil,
                 client_op,
                 nil
        end
      end
      
      def transform_update_attributes(client_op, server_op)
        case server_op.type
        when :retain
          if server_op.length > 1
            return DocOp.new(:retain, :length => 1),
                   nil,
                   client_op,
                   DocOp.new(:retain, :length => server_op.length - 1)
          else
            return DocOp.new(:retain, :length => 1),
                   nil,
                   client_op,
                   nil
          end
        when :delete_element_start
          return server_op,
                 nil,
                 nil,
                 nil
        when :replace_attributes
          return DocOp.new(:retain, :length => 1),
                 nil,
                 client_op,
                 nil
        when :update_attributes
          server_attributes = server_op.attributes
          client_op.attributes.each do |key, value|
            server_attributes.delete(key)
          end
          return DocOp.new(:update_attributes, :attributes => server_attributes),
                 nil,
                 client_op,
                 nil
        end
      end
      
      def transform_annotation_boundary(client_op, server_op)
        raise NotImplementedError
      end
    end
  end
end
