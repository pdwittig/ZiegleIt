require_relative '../models/treenode'
require_relative '../models/tree'

# Phils fucked up driver tests
tree = Tree.new
root = TreeNode.new("root")
tree.root = root
tree.leaves

child_a_1 = TreeNode.new("child_a_1")
child_a_2 = TreeNode.new("child_a_2")
child_b_1 = TreeNode.new("child_b_1")
child_b_2 = TreeNode.new("child_b_2")
child_c_1 = TreeNode.new("child_c_1")
child_c_2 = TreeNode.new("child_c_2")
child_d_1 = TreeNode.new("child_d_1")

root << child_a_1
root << child_a_2
child_a_1 << child_b_1
child_a_1 << child_b_2
child_a_2 << child_c_1
child_a_2 << child_c_2
child_b_1 << child_d_1

tree.leaves.each { |leaf| p leaf.name }
puts
tree.leaves(child_a_2).each { |leaf| p leaf.name }
puts 
puts child_b_1.children.last.name