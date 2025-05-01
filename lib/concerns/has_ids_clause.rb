module HasIdsClause
  extend ActiveSupport::Concern

  def ids_clause(ids, field, id_type)
    return "FALSE" if ids.empty?

    if id_type == :integer
      # Make sure all ids are integers to prevent SQL injection attacks.
      ids = ids.collect {|id| id.to_i}

      if kind_of?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
        "#{field} = ANY ('{#{ids.join(',')}}'::bigint[])"
      else
        "#{field} IN (#{ids.join(',')})"
      end
    elsif id_type == :string
      ids = ids.collect do |id|
        raise ArgumentError.new('Invalid id: #{id}') if id =~ /'/
        "'#{id}'"
      end
      "#{field} IN (#{ids.join(',')})"
    end
  end

end # module HasIdsClause

ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, HasIdsClause)