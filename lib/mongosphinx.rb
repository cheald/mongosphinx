# MongoSphinx, a full text indexing extension for using
# Sphinx.
#
# This file contains the includes implementing this library. Have a look at
# the README.rdoc as a starting point.
begin
  require 'rubygems'
rescue LoadError; end
require 'mongo_mapper'
require 'riddle'

module MongoSphinx
  if (match = __FILE__.match(/.*mongosphinx-([0-9.-]*)/))
    VERSION = match[1]
  else
    VERSION = 'unknown'
  end
  
  # Check if Sphinx is running.
  
  def self.sphinx_running?
    !!sphinx_pid && pid_active?(sphinx_pid)
  end

  # Get the Sphinx pid if the pid file exists.
  
  def self.sphinx_pid
    if File.exists?(MongoSphinx::Configuration.instance.pid_file)
      File.read(MongoSphinx::Configuration.instance.pid_file)[/\d+/]
    else
      nil
    end
  end
  
  def self.pid_active?(pid)
    !!Process.kill(0, pid.to_i)
  rescue Errno::EPERM => e
    true
  rescue Exception => e
    false
  end
  
end

require 'mongosphinx/multi_attribute'
require 'mongosphinx/configuration'
require 'mongosphinx/indexer'
require 'mongosphinx/mixins/indexer'
require 'mongosphinx/mixins/properties'


# Include the Indexer mixin from the original Document class of
# MongoMapper which adds a few methods and allows calling method indexed_with.

module MongoMapper # :nodoc:
  
  module Plugins
    
    module Document # :nodoc:
  
      module InstanceMethods
        include MongoMapper::Mixins::Indexer
        include MongoMapper::Mixins::Properties
      end
      
      module ClassMethods
        include MongoMapper::Mixins::Indexer::ClassMethods
      end
      
    end
  
  end
  
  module Document
    
    # For global indexing
    include MongoMapper::Mixins::Indexer
    
  end
  
end
  