module HasModelSet
  extend ActiveSupport::Concern

  module ClassMethods
    def has_set(name, options = {}, &extension)
      namespace = self.name.split('::')
      if namespace.empty?
        namespace = ''
      else
        namespace[-1] = ''
        namespace = namespace.join('::')
      end

      if options[:set_class]
        options[:set_class] = namespace + options[:set_class]
        other_class         = options[:set_class].constantize.model_class
      else
        options[:class_name] ||= name.to_s.singularize.camelize
        options[:class_name] = namespace + options[:class_name].to_s
        options[:set_class]  = options[:class_name] + 'Set'
        other_class          = options[:class_name].constantize
      end

      set_class = begin
        options[:set_class].constantize
      rescue NameError
        module_eval "class ::#{options[:set_class]} < ModelSet; end"
        options[:set_class].constantize
      end

      extension_module = if extension
        Module.new(&extension)
      end

      initial_set_all = if options[:filters] && options[:filters].first == :all
        options[:filters].shift
        true
      end

      define_method name do |*args|
        @model_set_cache ||= {}
        @model_set_cache[name] = nil if args.first == true # Reload the set.
        if @model_set_cache[name].nil?

          if initial_set_all
            set = set_class.all
          else
            own_key = options[:own_key] || self.class.table_name.singularize + '_id'
            if options[:as]
              as_clause = "AND #{options[:as]}_type = '#{self.class}'"
              own_key = "#{options[:as]}_id" unless options[:own_key]
            end
            if options[:through]
              other_key = options[:other_key] || other_class.table_name.singularize + '_id'
              where_clause = "#{own_key} = #{id}"
              where_clause << " AND #{options[:through_conditions]}" if options[:through_conditions]
              set = set_class.find_by_sql %{
                SELECT #{other_key} FROM #{options[:through]}
                WHERE #{where_clause} #{as_clause}
              }
            else
              set = set_class.all.add_conditions!("#{set_class.table_name}.#{own_key} = #{id} #{as_clause}")
            end
          end

          set.instance_variable_set(:@parent_model, self)
          def set.parent_model
            @parent_model
          end

          if options[:filters]
            options[:filters].each do |filter_name|
              filter_name = "#{filter_name}!"
              if set.method(filter_name).arity == 0
                set.send(filter_name)
              else
                set.send(filter_name, self)
              end
            end
          end

          set.add_joins!(options[:joins]) if options[:joins]
          set.add_conditions!(options[:conditions]) if options[:conditions]
          set.order_by!(options[:order]) if options[:order]
          set.extend(extension_module) if extension_module
          @model_set_cache[name] = set
        end
        if options[:clone] == false or args.include?(:no_clone)
          @model_set_cache[name]
        else
          set = @model_set_cache[name].clone
          set.extend(extension_module) if extension_module
          set
        end
      end
    end # def has_set

    def reset_model_set_cache
      @model_set_cache = {}
    end

  end # module ClassMethods
end # module HasModelSet

ActiveRecord::Base.send :include, HasModelSet