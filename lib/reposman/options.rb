module Reposman
  class Options
    def initialize(options={})
      options.each do |name, value|
        send(:"#{name}=", value)
      end

      @overwritten = {}
    end

    def self.defaults
      {
        :repo_base => '',
        :chiliproject => '',
        :api_key => '',

        :owner => Process.euid,
        :group => Process.egid,

        # o=rwx, g=rx, o=
        # if group is not root, set-gid will be set
        :mode => 750,

        :scm => "subversion",
        :command => nil,
        :url => nil,

        :test => false,
        :force => false,
        :verbose => 0,
        :quiet => false
      }.freeze
    end

    def [](k)
      @overwritten.has_key?(k) ? @overwritten[k] : self.class.defaults[k]
    end

    def []=(k, v)
      v = v.strip if v.is_a?(String)
      @overwritten[k] = v
    end

    def keys
      self.class.defaults.keys
    end

    def values
      all.values
    end

    def all
      keys.inject({}){|result, key| result[key] = self[key]; result}
    end

    defaults.each_key do |key|
      define_method(key) do
        send(:"[]", key)
      end

      define_method(:"#{key}=") do |value|
        send(:"[]=", key, value)
      end

      define_method("#{key}?") do
        v = send(:"[]", key)
        case v
        when Numeric: v.to_i > 0
        else !!v
        end
      end
    end
  end
end