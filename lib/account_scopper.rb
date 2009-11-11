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
end