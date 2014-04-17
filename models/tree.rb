class Tree
	def root= root 
		@root = root
	end

	def leaves node = @root, leaves = [] 
		leaves << node if node.leaf?
		node.children.each { |child| leaves(child, leaves) }
		return leaves
	end
end
