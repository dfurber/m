module M
  module Permissions

    class Group
      attr_accessor :name
      attr_reader :permissions
      def initialize(name)
        @name = name
      end
      def permissions
        @permissions ||= []
      end
      def add_permission(permission)
        permissions << M::Permissions::Permission.new(permission, self)
      end
      def permission_list
        permissions.sort(&:name)
      end
    end
  end
end
