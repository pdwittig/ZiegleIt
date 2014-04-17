class TreeNode

	attr_reader :name, :children
	attr_accessor :parent

	def initialize(name)
		@name = name
		@children = []
	end

	def << child
		children << child
		child.parent = self
	end

	def leaf?
		children.length == 0
	end
end

