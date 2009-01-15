class ModelSet
  class Query
    deep_clonable

    def initialize(model_set = ModelSet)
      if model_set.kind_of?(Class)
        @set_class = model_set
      else
        @set_class = model_set.class
        anchor!(model_set.query) if model_set.query
      end
    end

    def order_by!(order)
      @sort_order = order
      clear_cache!
    end

    def unsorted!
      @sort_order = nil
      clear_cache!
    end

    def page!(page)
      @page   = page ? page.to_i : nil
      @offset = nil
      clear_limited_cache!
    end

    def limit!(limit, offset = nil)
      @limit  = limit  ? limit.to_i  : nil
      @offset = offset ? offset.to_i : nil
      @page   = nil if offset
      clear_limited_cache!
    end
    
    def unlimited!
      @limit  = nil
      @offset = nil
      @page   = nil
      clear_limited_cache!
    end
    
    def clear_limited_cache!
      @ids  = nil
      @size = nil
      self
    end
     
    def clear_cache!
      @count = nil
      clear_limited_cache!
    end

    attr_reader :set_class
    delegate :id_field, :table_name, :id_field_with_prefix, :model_class, :model_name, :to => :set_class

    attr_reader :limit, :sort_order

    def offset
      if @limit
        @offset ||= @page ? (@page - 1) * @limit : 0
      end
    end

    def page
      if @limit
        @page ||= @offset ? (@offset / @limit) : 1
      end
    end

    def before_query(*args)
      proc = self.class.before_query
      proc.bind(self).call(*args) if proc
    end
    
    def self.before_query(&block)
      if block
        @before_query = block
      else
        @before_query
      end
    end

    def on_exception(*args)
      proc = self.class.on_exception
      proc ? proc.bind(self).call(*args) : raise(args.first)
    end

    def self.on_exception(&block)
      if block
        @on_exception = block
      else
        @on_exception
      end
    end

    def after_query(*args)
      proc = self.class.after_query
      proc.bind(self).call(*args) if proc
    end

    def self.after_query(*args, &block)
      if block
        @after_query = block
      else
        @after_query
      end
    end

  end
end
