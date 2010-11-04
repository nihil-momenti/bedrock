require 'models/docop'

module Rave
  module Models
    module Transformer
      def transform(first, second)
          eval <<-STR
            if respond_to? transform_#{first.type}_#{second.type}
              return transform_#{first.type}_#{second.type}(first, second)
            elif respond_to? transform_#{second.type}_#{first.type}
              result = transform_#{second.type}_#{first.type}(second, first)
              return result[2], result[3], result[0], result[1]
            else
              raise "Invalid operation"
          STR
      end

      private

      def transform_retain_retain(first, second)
        if first.length > second.length
          return DocOp.new(:retain, :length => second.length),
                 DocOp.new(:retain, :length => first.length - second.length),
                 DocOp.new(:retain, :length => second.length),
                 nil
        else
          return DocOp.new(:retain, :length => self.length),
                 nil,
                 DocOp.new(:retain, :length => self.length),
                 DocOp.new(:retain, :length => other.length - self.length)
        end
      end
      
      def transform_retain_insert_text(first, second)
        return second,
               first,
               DocOp.new(:retain, :length => second.text.length),
               nil
      end
      
      def transform_retain_insert_element_start(first, second)
        return second,
               first,
               DocOp.new(:retain, :length => 1),
               nil
      end
      
      def transform_retain_insert_element_end(first, second)
        return second,
               first,
               DocOp.new(:retain, :length => 1),
               nil
      end
      
      def transform_retain_delete_text(first, second)
        return second,
               first,
               nil,
               nil
      end
      
      def transform_retain_delete_element_start(first, second)
        return second,
               first,
               nil,
               nil
      end
      
      def transform_retain_delete_element_end(first, second)
        return second,
               first,
               nil,
               nil
      end
      
      def transform_retain_replace_attributes(first, second)
        return second,
               nil,
               DocOp.new(:retain, :length => 1),
               nil
      end
      
      def transform_retain_update_attributes(first, second)
        return second,
               nil,
               DocOp.new(:retain, :length => 1),
               nil
      end
      
      def transform_retain_annotation_boundary(first, second)
        raise NotImplementedError  
      end
    
      def transform_insert_text_insert_text(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_insert_element_start(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_insert_element_end(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_delete_text(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_delete_element_start(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_delete_element_end(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_replace_attributes(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_update_attributes(first, second)
        return DocOp.new(:retain, :length => first.text.length),
               nil,
               first,
               second
      end
      
      def transform_insert_text_annotation_boundary(first, second)
        raise NotImplementedError
      end
      
      def transform_insert_element_start_insert_element_end(first, second)
      
      end
    
#        :retain
#        :insert_text
#        :insert_element_start
#        :insert_element_end
#        :delete_text
#        :delete_element_start
#        :delete_element_end
#        :replace_attributes
#        :update_attributes
#        :annotation_boundary
    end
  end
end

