require 'pathname'
require 'nokogiri'

require_relative '../models/tree'
require_relative '../models/treenode'
require_relative '../models/summary'
require_relative '../modules/parser'
require_relative '../modules/algorithm'

APP_ROOT = Pathname.new(File.expand_path(File.join(File.dirname(__FILE__), '..')))

APP_NAME = APP_ROOT.basename.to_s

# autoload :TreeNode,   'models/treenode'
# autoload :Tree,       'models/tree'
# autoload :Parser,     'modules/parser'

# Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
#   puts "anything"
#   filename = File.basename(model_file).gsub('.rb', '')
#   autoload ActiveSupport::Inflector.camelize(filename), model_file
# end