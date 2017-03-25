module Yumi
  module Presenters
    class RootLinks
      def initialize(current_url, params, total, collection)
        @current_url = current_url
        @params = params
        @total = total
        @collection = collection

        if @collection
          @params[:page] = @params[:page] ? @params[:page].to_i : 1
          @params[:per] = @params[:per] ? @params[:per].to_i : 10
        end
      end

      def to_json_api
        @hash = { self: build_current_url }

        if @collection
          set_first_page
          set_last_page
          set_previous_page
          set_next_page
        end

        @hash
      end

      private

      def set_first_page
        @hash[:first] = build_current_url.gsub(/page=\d+/, 'page=1')
      end

      def set_last_page
        if max_page > 0
          @hash[:last] = build_current_url.gsub(/page=\d+/, "page=#{max_page}")
        end
      end

      def set_previous_page
        prev_page = @params[:page] - 1
        if prev_page > 0
          @hash[:prev] = build_current_url.gsub(/page=\d+/, "page=#{prev_page}")
        end
      end

      def set_next_page
        next_page = @params[:page] + 1
        if next_page <= max_page
          @hash[:next] = build_current_url.gsub(/page=\d+/, "page=#{next_page}")
        end
      end

      def max_page
        @max_page ||= @total ? (@total / @params[:per].to_f).ceil : 0
      end

      def build_current_url
        return @current_url unless @params.any?

        base = @current_url.split('?')[0]

        @params.each_with_index do |(key, value), i|
          if i == 0
            base << "?#{key}=#{value}"
          else
            base << "&#{key}=#{value}"
          end
        end

        base
      end
    end
  end
end
