class TreeNode

	attr_accessor :parent, :name, :children

	def initialize(name)
		@name = name
		@children = []
	end

	def << child
		children << child
		child.parent = self
	end

	def leaves
		leaves = []
		return
	end

	def leaf?
		children.length == 0
	end

end

root = TreeNode.new("dad")
child1 = TreeNode.new("son")
root << child1

p child1.parent.name
p root.leaf?
p child1.leaf?
