module M
  module Permissions

    class List

      attr_reader :permissions, :groups
      attr_accessor :registry

      def initialize
        @registry = []
      end

      def permissions
        @permissions ||= []
      end

      def groups
        @groups ||= []
      end

      def group_list
        groups.sort &:name
      end

      def add(group, permission)
        pgroup = groups.select {|g| g.name == group}
        group = pgroup.blank? ? add_group(group) : pgroup.first
        permission = group.add_permission(permission)
        add_permission(permission)
      end

      def resource(name, group, actions)
        @registry << name
        plural_name = name.to_s.underscore.gsub(/_/,' ').pluralize.downcase
        add group, "access #{plural_name}" if actions.include?(:read)
        add group, "add new #{plural_name}" if actions.include?(:create)
        add group, "edit #{plural_name}"  if actions.include?(:update)
        add group, "delete #{plural_name}"  if actions.include?(:destroy)
      end

      private

      def add_group(group)
        new_group = M::Permissions::Group.new(group)
        groups << new_group
        new_group
      end

      def add_permission(permission)
        permissions << permission
      end

    end  
  end
end