module ActiveRecord # :nodoc:
  class Base # :nodoc:
    class << self # Class methods
      alias_method :orig_delete_all, :delete_all
      def delete_all(conditions = nil)
        if Account.current_account != nil && column_names.include?("account_id")
          with_scope(:find => {:conditions => "account_id = "+Account.current_account.id.to_s}) do
            orig_delete_all(conditions)
          end
        else
          orig_delete_all(conditions)
        end
      end
      
      alias_method :orig_calculate, :calculate
      def calculate(operation, column_name, options = {})
        if Account.current_account != nil && column_names.include?("account_id")
          with_scope(:find => {:conditions => ["account_id = ?", Account.current_account.id]}) do
            orig_calculate(operation, column_name, options)
          end
        else
          orig_calculate(operation, column_name, options)
        end
      end
      
      private
        alias_method :orig_find_every, :find_every
        def find_every(options)
          if Account.current_account != nil && column_names.include?("account_id")
            with_scope(:find => {:conditions => self.table_name+".`account_id` = "+Account.current_account.id.to_s}) do
              orig_find_every(options)
            end
          else
            orig_find_every(options)
          end
        end
    end
    
    # Instance methods, they are called from an instance of a model (an object)
    alias_method :orig_destroy, :destroy
    def destroy
      if !Account.current_account.nil? && respond_to?(:account_id)
        orig_destroy if self.account_id == Account.current_account.id
      else
        orig_destroy
      end
    end
    
    private
      alias_method :orig_create, :create
      def create
        if !Account.current_account.nil? && respond_to?(:account_id)
          self.account_id = Account.current_account.id
        end
        orig_create
      end
  end

  module Validations
    module ClassMethods
      # Allow to validates uniqueness without scoping to the current account.
      def validates_global_uniqueness_of(*attr_names)
        configuration = { :case_sensitive => true }
        configuration.update(attr_names.extract_options!)

        validates_each(attr_names,configuration) do |record, attr_name, value|

          # The check for an existing value should be run from a class that
          # isn't abstract. This means working down from the current class
          # (self), to the first non-abstract class. Since classes don't know
          # their subclasses, we have to build the hierarchy between self and
          # the record's class.
          class_hierarchy = [record.class]
          while class_hierarchy.first != self
            class_hierarchy.insert(0, class_hierarchy.first.superclass)
          end

          # Now we can work our way down the tree to the first non-abstract
          # class (which has a database table to query from).
          finder_class = class_hierarchy.detect { |klass| !klass.abstract_class? }

          column = finder_class.columns_hash[attr_name.to_s]

          if value.nil?
            comparison_operator = "IS ?"
          elsif column.text?
            comparison_operator = "#{connection.case_sensitive_equality_operator} ?"
            value = column.limit ? value.to_s.mb_chars[0, column.limit] : value.to_s
          else
            comparison_operator = "= ?"
          end

          sql_attribute = "#{record.class.quoted_table_name}.#{connection.quote_column_name(attr_name)}"

          if value.nil? || (configuration[:case_sensitive] || !column.text?)
            condition_sql = "#{sql_attribute} #{comparison_operator}"
            condition_params = [value]
          else
            condition_sql = "LOWER(#{sql_attribute}) #{comparison_operator}"
            condition_params = [value.mb_chars.downcase]
          end

          if scope = configuration[:scope]
            Array(scope).map do |scope_item|
              scope_value = record.send(scope_item)
              condition_sql << " AND " << attribute_condition("#{record.class.quoted_table_name}.#{scope_item}", scope_value)
              condition_params << scope_value
            end
          end

          unless record.new_record?
            condition_sql << " AND #{record.class.quoted_table_name}.#{record.class.primary_key} <> ?"
            condition_params << record.send(:id)
          end

          # Remove current account to prevent scopping
          account = Account.current_account
          Account.current_account = nil

          finder_class.with_exclusive_scope do
            if finder_class.exists?([condition_sql, *condition_params])
              record.errors.add(attr_name, :taken, :default => configuration[:message], :value => value)
            end
          end

          # Restore current account
          Account.current_account = account
        end
      end
    end
  end
end