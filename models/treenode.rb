class TreeNode

	attr_reader :content, :depth
	attr_accessor :parent, :children

	def initialize(args)
		@content = args[:content] ||= ""
		@children = args[:children] ||= []
		@depth = args[:depth] ||= 0
	end

	def << child
		children << child
		child.parent = self
	end

	def leaf?
		children.length == 0
	end
end

