module Axe
  module API
    class Context
      attr_reader :inclusion, :exclusion

      def initialize
        @inclusion = []
        @exclusion = []
      end

      def include(selector)
        @inclusion.concat ensure_nested_array(selector)
      end

      def exclude(selector)
        @exclusion.concat ensure_nested_array(selector)
      end

      def to_hash
        {}.tap do |context_param|
          # include key must not be included if empty
          # (when undefined, defaults to `document`)
          context_param[:include] = @inclusion unless @inclusion.empty?

          # exclude array allowed to be empty
          # and must exist in case `include` is omitted
          # because context_param cannot be empty object ({})
          context_param[:exclude] = @exclusion
        end
      end

      def to_json
        if @inclusion.empty?
          if @exclusion.empty?
            "document"
          else
            %Q({"include":document,"exclude":#{@exclusion.to_json}})
          end
        else
          to_hash.to_json
        end
      end

      alias :to_s :to_json

      private

      def ensure_nested_array(selector)
        Array(selector).map { |s| Array(s) }
      end

    end
  end
end
