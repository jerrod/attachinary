module Attachinary
  module FileMixin
    def self.included(base)
      base.validates :public_id, :version, :resource_type, presence: true
      base.attr_accessible :public_id, :version, :width, :height, :format, :resource_type
      base.after_destroy :destroy_file
      base.after_create  :remove_temporary_tag
    end

    def as_json(options)
      super(only: [:id, :public_id, :format, :version, :resource_type], methods: [:path], root: false)
    end

    def path(custom_format=nil)
      p = "v#{version}/#{public_id}"
      if resource_type == 'image' && custom_format != false
        custom_format ||= format
        p<< ".#{custom_format}"
      end
      p
    end

    def fullpath(options={})
      format = options.delete(:format)
      Cloudinary::Utils.cloudinary_url(path(format), options)
    end

  private
    def destroy_file
      Cloudinary::Uploader.destroy(public_id) if public_id
    end

    def remove_temporary_tag
      Cloudinary::Uploader.remove_tag(Attachinary::TMPTAG, [public_id]) if public_id
    end

  end
end
