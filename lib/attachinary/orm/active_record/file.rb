module Attachinary
  class File < ::ActiveRecord::Base
    belongs_to :attachinariable, polymorphic: true
    attr_accessible :public_id, :version, :width, :height, :format, :resource_type
    include FileMixin
  end
end
