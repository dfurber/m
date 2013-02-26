module M
  module Permissions
    class Permission
      attr_accessor :name, :group
      def initialize(name, group)
        @name, @group = name, group
      end
    end
  end

end
