module Kong
  class Target
    include Base

    ATTRIBUTE_NAMES = %w(id upstream target weight).freeze
    API_END_POINT = '/targets/'.freeze

    def self.find(id)
      raise NotImplementedError, 'Kong does not support direct access to targets, you must go via an upstream'
    end

    def self.list(params = {})
      raise NotImplementedError, 'Kong does not support direct access to targets, you must go via an upstream'
    end

    def initialize(attributes = {})
      super(attributes)
      raise ArgumentError, 'You must specify an upstream with id' unless attributes['upstream'] && attributes['upstream']['id']
    end

    def active?
      self.weight > 0
    end

    def save
      create
    end

    def create_or_update
      raise NotImplementedError, 'Kong does not support updating targets, you must delete and re-create'
    end

    def update
      raise NotImplementedError, 'Kong does not support updating targets, you must delete and re-create'
    end

    def use_upstream_end_point
      self.api_end_point = "/upstreams/#{self.attributes['upstream']['id']}#{self.class::API_END_POINT}" if self.attributes['upstream'] && self.attributes['upstream']['id']
    end

    # Get Upstream resource
    # @return [Kong::Upstream]
    def upstream
      @upstream ||= Upstream.find(self.attributes['upstream']['id'])
    end

    # Set Upstream resource
    # @param [Kong::Upstream] upstream
    def upstream=(upstream_id)
      self.attributes["upstream"]["id"] = upstream_id
      @upstream = Upstream.find(self.attributes['upstream']['id'])
    end

  end
end
