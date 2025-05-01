require 'concerns/has_ids_clause'

class ModelSet
  class SQLBaseQuery < Query
    # SQL methods common to SQLQuery and RawSQLQuery.
    def ids
      @ids ||= fetch_id_set(sql)
    end

    def size
      @size ||= ids.size
    end

  private

    def ids_clause(ids, field = id_field_with_prefix)
      db.ids_clause(ids, field, set_class.id_type)
    end

    def fetch_id_set(sql)
      db.select_values(sql).collect { |id| set_class.id_type == :integer ? id.to_i : id }.to_ordered_set
    end

    def db
      model_class.connection
    end

    def sanitize_condition(condition)
      model_class.sanitize_sql_for_assignment(condition)
    end

    def transform_condition(condition)
      [sanitize_condition(condition)]
    end

    def limit_clause
      return unless limit
      limit_clause = "LIMIT #{limit}"
      limit_clause << " OFFSET #{offset}" if offset > 0
      limit_clause
    end
  end
end