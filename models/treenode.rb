class TreeNode
	attr_reader :content, :depth, :words
	attr_accessor :parent, :children, :rbss, :quota, :fv

	def initialize(args)
		@content = args[:content] ||= ""
		@words = args[:words] ||= []
		@children = args[:children] ||= []
		@depth = args[:depth] ||= 0
		@rbss = 0
		@quota = 0
		@fv = 0
	end

	def << child
		children << child
		child.parent = self
	end

	def leaf?
		children.length == 0
	end

	def to_s
		str = "  " * @depth
		str << "Depth: #{depth}, Number of children: #{@children.length}, RBSS: #{@rbss}, FV: #{@fv}, Quota: #{@quota}"
	end
end
